function quad_props_init()
	local handles = {-1, -1, -1, -1}
	for i = 1, 4, 1 do
	    handles[i] = simGetObjectHandle('Quadricopter_propeller_respondable'..i)
	end
	return handles
end

function quad_props_set_thrusts(handles, thrusts)
	assert(#thrusts == 4 and #thrusts == #handles, "Expecting the size of propellers' thrusts to be exactly 4, but got "..#thrusts);

	-- lock the thread
	simSetThreadIsFree(true)
	
	for i = 1, #handles do
	    -- set float signals to the respective propellers, and propeller respondables
	    simSetFloatSignal('Quadricopter_propeller_respondable'..i, handles[i])
	    -- set the thrust to the i'th propeller
	    simSetFloatSignal('thrust'..i,  thrusts[i])
	end

	-- unlock the thread
	simSetThreadIsFree(false)
end

function quad_pos(handle)
	return simGetObjectPosition(handles, -1)
end

function quad_alt(handle)
	assert(false, 'Not Implemented!!')
end