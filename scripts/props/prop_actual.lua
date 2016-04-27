local force = {0, 0, 0}
local torque = {0, 0, 0}

local prop_respondable = simGetFloatSignal('Quadricopter_propeller_respondable'..PROPID)

for i = 1, 3, 1 do
    force[i]  = simGetFloatSignal('force'..PROPID..i)
    torque[i] = simGetFloatSignal('torque'..PROPID..i)
end

if prop_respondable ~= nil then
	simAddForceAndTorque(prop_respondable, force, torque)
end