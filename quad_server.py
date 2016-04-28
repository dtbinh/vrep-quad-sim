#!/usr/bin/env python

'''
quad_server.py - The remote server of quad, launched from VREP simulator.

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
'''
import traceback
import numpy as np
from sys import argv, exit
from utils.py import networking as net

# serve a socket on the port indicated in the first command-line argument
client = net.server.accept(int(argv[1]))
# init handshake and fetch metadata
meta = net.initiate_handshake(client)

print "Version:", meta["VERSION"], "\nWorking Directory:", meta["PWD"]

print "[OK] Server/Client connection"

while True:
    try:
    	# recieve data from client
        request = net.rcvJSON(client)
        # check request type
        if(request["type"] == "fetch"):
        	# check the executive command
        	if(request["execute"] == "thrusts?"):
        		# resport the thrusts values
        		net.sendJSON(client, {"respond": "ok", "data": [5.5, 5.5, 5.5, 5.5]})
        		continue;
		# if we reach here, we have invalid command!!
		print "Invalid request", request;
		net.sendJSON(client, {"respond": "invalid", "data": False})
    except Exception as e:
        # inform and exit on exception
        print "ERROR:", str(e), "\n", traceback.format_exc(), exit(0)