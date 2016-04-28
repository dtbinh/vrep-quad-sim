--[[
quad_client.lua - The processing script of quad, executed from VREP simulator.

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

-- send a request to server
sendJSON(server, { ["type"] = "fetch", ["execute"] = "thrusts?", ["data"] = quad_get_status(quad) })
-- receive a response
result = rcvJSON(server);
-- check if respond is OK?
if(result["respond"] == "ok") then
	-- set propellers' thrust
	quad_props_set_thrusts(handle_quad_props, result["data"])
else
	print("Invalid data: "..inspect(result))
	simStopSimulation()
end