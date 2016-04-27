function quad_prop_init()
	local handles = {-1, -1, -1, -1}
	for i = 1, 4, 1 do
	    handles[i] = simGetScriptHandle('Quadricopter_propeller_respondable'..i)
	end
	return handles
end

function quad_prop_set(handles, speeds)
	assert(#speeds == 4 and #speeds == #handles, "Expecting the size of propellers' speed to be exactly 4, but got "..#speeds);
	for i = 1, #handles do
		simSetScriptSimulationParameter(handles[i], 'particleVelocity',speeds[i])
    end
end