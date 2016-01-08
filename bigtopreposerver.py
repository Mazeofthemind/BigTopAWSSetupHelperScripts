#!/usr/bin/python

#This is a simple python based http server that is designed to run as a daemon and serve the BigTop local package repository
#Note the default package repository (/tmp/localrepo) and port (9000)

import SimpleHTTPServer
import SocketServer
import os

PORT = 9000
ABSOLUTE_PATH_LOCALREPO = "/tmp/localrepo"

os.chdir(ABSOLUTE_PATH_LOCALREPO)

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()
