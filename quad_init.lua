--[[
quad_init.lua - The initializing script of quad, executed from VREP simulator.

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

os.execute( "clear" )

-- define modules
local modules = {
	'inspect',
	'utilities',
	'networking',
	'quad_engine'
};
-- loading modules
for index, _module in pairs(modules) do
	_G[_module] = (loadfile(PWD..'/utils/lua/'.._module..'.lua'))();
	print("[+] module `".._module..'`');
end

-- quad_prop = quad_prop_init();

propellerList = {}
propellerRespondableList = {}

-- Get the object handles for the propellers and respondables
for i = 1, 4, 1 do
    propellerList[i]=simGetObjectHandle('Quadricopter_propeller'..i)
    propellerRespondableList[i]=simGetObjectHandle('Quadricopter_propeller_respondable'..i)

end

particleCountPerSecond = 430 -- simGetScriptSimulationParameter(sim_handle_self,'particleCountPerSecond')
particleDensity = 8500 --simGetScriptSimulationParameter(sim_handle_self,'particleDensity')

baseParticleSize = 1--simGetScriptSimulationParameter(sim_handle_self,'particleSize')
timestep = simGetSimulationTimeStep()

-- Compute particle sizes
particleSizes = {}

for i = 1, 4, 1 do
    propellerSizeFactor = simGetObjectSizeFactor(propellerList[i]) 
    particleSizes[i] = baseParticleSize*0.005*propellerSizeFactor
end

particleCount = math.floor(particleCountPerSecond * timestep)

simSetThreadIsFree(true)

-- Set forces and torques for each propeller
for i = 1, 4, 1 do

    thrust = 5.5

    force = particleCount * particleDensity * thrust * math.pi * math.pow(particleSizes[i],3) / (6*0.05)
    
    torque = math.pow(-1, i+1)*.002 * thrust

    -- Set float signals to the respective propellers, and propeller respondables
    simSetFloatSignal('Quadricopter_propeller_respondable'..i, propellerRespondableList[i])

    propellerMatrix = simGetObjectMatrix(propellerList[i], -1)

    forces  = scalarTo3D(force, propellerMatrix)
    torques = scalarTo3D(torque, propellerMatrix)

    -- Set force and torque for propeller
    for k = 1, 3, 1 do
        simSetFloatSignal('force'..i..k,  forces[k])
        simSetFloatSignal('torque'..i..k, torques[k])
    end

end

simSetThreadIsFree(false)

-- Thread switch configs
simSetThreadSwitchTiming(200)
simSetThreadAutomaticSwitch(true)

-- get quad's handle
quad = simGetObjectHandle('Quadricopter_base')

-- connect with server
server = server_connect(PWD..'/quad_server.py')

-- initiate a handshake
initiate_handshake(server)