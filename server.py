import http.server
import socketserver
from pymongo import MongoClient

# Set up MongoDB connection
client = MongoClient("mongodb://localhost:27017/")
db = client["your_database_name"]  # Replace "your_database_name" with your actual database name
collection = db["your_collection_name"]  # Replace "your_collection_name" with your actual collection name

PORT = 8000

Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port", PORT)

    # You can add your MongoDB-related code here
    # For example, inserting a document:
    data = {"key": "value"}
    collection.insert_one(data)

    httpd.serve_forever()