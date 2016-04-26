'''
networking.py - The Python networking engine for communication between quad's client and server modules.

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

import time
import json
import struct
import socket_server as server

# define timeout second
TIMEOUT_SEC      = 1.0

def sendFloats(client, data):
    client.send(struct.pack('%sf' % len(data), *data))

def unpackFloats(msg, nfloats):
    return struct.unpack('f'*nfloats, msg)

def rcvFloats(client, nfloats):
    # We use 32-bit floats
    msgsize = 4 * nfloats

    # Implement timeout
    start_sec = time.time()
    remaining = msgsize
    msg = ''
    while remaining > 0:
        msg += client.recv(remaining)
        remaining -= len(msg)
        if (time.time()-start_sec) > TIMEOUT_SEC:
            return None

    return unpackFloats(msg, nfloats)

def sendString(client, _str):
	sendFloats(client, [len(_str)]);
	client.send(_str)

def rcvString(client):
    return client.recv(int(rcvFloats(client, 1)[0]))

def sendJSON(client, data):
	sendString(client, json.dumps(data))

def rcvJSON(client):
	return json.loads(rcvString(client))

def initiate_handshake(client):
    if(rcvString(client) != "220 EHLO SERVER"):
        print("Server: Wrong Handshake!");
        exit(-1);
    else:
        sendString(client, "250 Acknowledged Handshake")
    # handshake went OK, rcv metadata
    meta = rcvJSON(client);
    print "Server: valid handshake."
    return meta 