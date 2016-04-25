
function sendFloats(server, data)
    server:send(simPackFloats(data))
end

function receiveFloats(server, count)
    data = server:receive(4*count)
    return simUnpackFloats(data)
end

function sendString(server, str)
    sendFloats(server, { string.len(str) })
    server:send(str)
end

function connect_server(SERVER_EXECUTABLE)
    print("connecting to server...")
    local portNb = simGetInt32Parameter(sim_intparam_server_port_next)
    local portStart = simGetInt32Parameter(sim_intparam_server_port_start)
    local portRange = simGetInt32Parameter(sim_intparam_server_port_range)
    local newPortNb = portNb + 1
    if (newPortNb>=portStart+portRange) then
        newPortNb=portStart
    end

    simSetInt32Parameter(sim_intparam_server_port_next, newPortNb)
    simSetThreadAutomaticSwitch(true)

    -- Set the last argument to 1 to see the console of the launched server
    serverResult = simLaunchExecutable(SERVER_EXECUTABLE, portNb, 0)

    -- Attempt to launch the executable server script
    if (serverResult==-1) then
        simDisplayDialog('Error',
        'Server '..SERVER_EXECUTABLE..' could not be launched. &&n'..
        'Please make sure that it exists and is executable. Then stop and restart the simulation.',
        sim_dlgstyle_message,false, nil,{0.8,0,0,0,0,0},{0.5,0,0,1,1,1})
        simPauseSimulation()
    end

    -- On success, attempt to connect to server
    while (serverResult ~= -1 and simGetSimulationState()~=sim_simulation_advancing_abouttostop) do
        -- The executable could be launched. Now build a socket and connect to the server:
        local socket = require("socket")
        local server = socket.tcp()
        if server:connect('127.0.0.1', portNb) == 1 then break; end
    end
    return server
end

threadFunction = function()
    -- 
    sendString(server, "EHLO SERVER")

    simSwitchThread()

end

simSetThreadSwitchTiming(2) -- Default timing for automatic thread switching

-- Modify PYQUADSIM_HOME variable in script from .ttt
PYQUADSIM_HOME = '/home/dariush/Desktop/q'

server = connect_server(PYQUADSIM_HOME..'/server.py')


-- base = simGetObjectHandle('Quadricopter_base')

-- propellerList = {}
-- propellerRespondableList = {}

-- -- Get the object handles for the propellers and respondables
-- for i = 1, 4, 1 do
--     propellerList[i]=simGetObjectHandle('Quadricopter_propeller'..i)
--     propellerRespondableList[i]=simGetObjectHandle('Quadricopter_propeller_respondable'..i)
-- end

-- propellerScripts={-1,-1,-1,-1}
-- for i=1,4,1 do
--     propellerScripts[i]=simGetScriptHandle('Quadricopter_propeller_respondable'..i)
-- end

-- particlesTargetVelocities = {5.35, 5.35, 5.35, 5.35}

-- -- Send the desired motor velocities to the 4 rotors:
-- for i=1,4,1 do
--     simSetScriptSimulationParameter(propellerScripts[i],'particleVelocity',particlesTargetVelocities[i])
-- end
-- Here we execute the regular thread code:
res,err=xpcall(threadFunction,function(err) return debug.traceback(err) end)
if not res then
    simAddStatusbarMessage('Lua runtime error: '..err)
end