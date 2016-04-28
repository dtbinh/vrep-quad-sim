--[[
prop_actuation.lua - The propellers' actuation executor, executed from VREP simulator.

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

local thrust = simGetFloatSignal('thrust'..PROPID)

if thrust ~= nil then
	local prop_respondable = simGetFloatSignal('Quadricopter_propeller_respondable'..PROPID)

	local torque 	= math.pow(-1, PROPID) * 1e-20 * thrust
	local force 	= particleDensity * particleCount * thrust * math.pi * math.pow(particleSizes, 3) / 6

	local prop_mat 	= simGetObjectMatrix(prop, -1)

	-- for efficiency purposes we don't use `scalarTo3D()` function in `/utils/lua/utilities.lua`
	local forces  	= { force * prop_mat[3], force * prop_mat[7], force * prop_mat[11] }
	local torques 	= { torque * prop_mat[3], torque * prop_mat[7], torque * prop_mat[11] }

	if prop_respondable ~= nil then
		simAddForceAndTorque(prop_respondable, forces, torques)
	end
end