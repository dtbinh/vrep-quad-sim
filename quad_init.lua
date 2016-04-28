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

-- Thread switch configs
simSetThreadSwitchTiming(200)
simSetThreadAutomaticSwitch(true)

-- get quad's handle
quad = simGetObjectHandle('Quadricopter_base')

-- init quad's initial position
simSetObjectPosition(quad, -1, {0, 0, 0})
-- init quad's initial orientation
simSetObjectOrientation(quad, -1, {0, 0, 0})

-- fetch quad's propellers' handler
handle_quad_props = quad_props_init();

-- connect with server
server = server_connect(PWD..'/quad_server.py')

-- initiate a handshake
initiate_handshake(server)