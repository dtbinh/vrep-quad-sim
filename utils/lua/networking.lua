--[[
networking.lua - The Lua networking engine for communication between quad's client and server modules.

    Copyright (c) 2016 Dariush Hasanpour

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]--

JSON = (loadfile(PWD..'/utils/lua/JSON.lua'))()

function server_connect(SERVER_EXECUTABLE)
    local portNb = simGetInt32Parameter(sim_intparam_server_port_next)
    local portStart = simGetInt32Parameter(sim_intparam_server_port_start)
    local portRange = simGetInt32Parameter(sim_intparam_server_port_range)
    local newPortNb = portNb + 1
    if (newPortNb >= portStart + portRange) then
        newPortNb = portStart
    end

    simSetInt32Parameter(sim_intparam_server_port_next, newPortNb)

    local serverResult = simLaunchExecutable(SERVER_EXECUTABLE, portNb, 0) 

    -- Attempt to launch the executable server script
    if (serverResult==-1) then
        simDisplayDialog('Error',
            'Server '..SERVER_EXECUTABLE..' could not be launched. &&n'..
            'Please make sure that it exists and is executable. Then stop and restart the simulation.',
            sim_dlgstyle_message, false,  nil, {0.8,0,0,0,0,0}, {0.5,0,0,1,1,1})
        simPauseSimulation()
    end

    -- On success, attempt to connect to server
    while (serverResult ~= -1 and simGetSimulationState() ~= sim_simulation_advancing_abouttostop) do
        -- The executable could be launched. Now build a socket and connect to the server:
        local socket = require("socket")
        local server = socket.tcp()
        if server:connect('127.0.0.1', portNb) == 1 then
            return server
        end
    end
end

function server_close(server)
    server:close()
end

function initiate_handshake(server)
    sendString(server, "220 EHLO SERVER")

    if not string.match(rcvString(server), "250 .+") then
        print("Client: Wrong Handshake!")
        simStopSimulation()
    else
        print("Client: valid handshake.")
    end

    -- handshake went OK, send metadata
    sendJSON(server, { ["PWD"] = PWD, ["VERSION"] = VERSION })
end

function sendFloats(server, data)
    server:send(simPackFloats(data))
end

function rcvFloats(server, count)
    data = server:receive(4 * count)
    return simUnpackFloats(data)
end

function sendString(server, str)
    sendFloats(server, {string.len(str)})
    server:send(str)
end

function rcvString(server)
    return server:receive(rcvFloats(server, 1)[1]);
end

function sendJSON(server, data)
    sendString(server, JSON:encode(data))
end

function rcvJSON(server)
    return JSON:decode(rcvString(server))
end