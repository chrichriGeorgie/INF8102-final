import http.server
import socketserver
from pymongo import MongoClient

uri = "mongodb+srv://celinagmunoz:inf8102tpfinal@inf8102.tn5wek3.mongodb.net/?retryWrites=true&w=majority"
client = MongoClient(uri)

# Access a specific database and collection 
db = client["INF8102"]
collection = db["Tp final"]

PORT = 8000

Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port", PORT)

    # You can add your MongoDB-related code here
    # For example, inserting a document:
    data = {"key": "value"}
    collection.insert_one(data)

    httpd.serve_forever()
