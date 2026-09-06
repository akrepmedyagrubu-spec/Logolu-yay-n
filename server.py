from http.server import SimpleHTTPRequestHandler
from socketserver import TCPServer
import os

PORT = 10000

os.chdir("/app")

handler = SimpleHTTPRequestHandler

httpd = TCPServer(("", PORT), handler)

print("Server running on port", PORT)
httpd.serve_forever()
