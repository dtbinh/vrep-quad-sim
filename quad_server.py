#!/usr/bin/env python

import os
import time
import struct
import socket_server
from sys import argv, exit

TIMEOUT_SEC      = 1.0


def sendFloats(client, data):
    client.send(struct.pack('%sf' % len(data), *data))

def unpackFloats(msg, nfloats):
    return struct.unpack('f'*nfloats, msg)

def receiveFloats(client, nfloats):
 
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
    
def receiveString(client):
    return client.recv(int(receiveFloats(client, 1)[0]))

os.system("clear")

# Serve a socket on the port indicated in the first command-line argument
client = socket_server.listen(int(argv[1]))

while True:
	print "RCV FROM CLIENT: ", receiveString(client);