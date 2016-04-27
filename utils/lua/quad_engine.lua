--[[
quad_engine.lua - Handles the engine part of quad, executed from VREP simulator.

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
	return simGetObjectPosition(handle, -1)
end

function quad_alt(handle)
	assert(false, 'Not Implemented!!')
end