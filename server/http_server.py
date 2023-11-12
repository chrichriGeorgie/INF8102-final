import http.server
import socketserver
from pymongo import MongoClient
import requests  # Import the requests library

uri = "mongodb+srv://celinagmunoz:inf8102tpfinal@inf8102.tn5wek3.mongodb.net/?retryWrites=true&w=majority"
client = MongoClient(uri)

# Access a specific database and collection
db = client["INF8102"]
collection = db["Tp final"]

PORT = 8000

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')
        # Process the POST data as needed
        print("Received POST data:", post_data)

        # Example: Insert the received data into MongoDB
        data = {"received_data": post_data}
        collection.insert_one(data)

        # Respond to the client
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'POST request received successfully')

with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()
