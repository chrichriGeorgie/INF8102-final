import http.server
import socketserver
import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table_name = 'INF8102_TP_Final'
partition_key = 'UserId'  

PORT = 8000

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')

        print("Received POST data:", post_data)

        try:
            # Create a unique ID for each entry
            entry_id = str(uuid.uuid4())
            user_id = "user123"  

            response = table.put_item(
                Item={
                    'UserId': user_id,  
                    'EntryID': entry_id,  
                    'Data': post_data
                }
            )
            print("Data inserted into DynamoDB:", response)
        except Exception as e:
            print(f"Error inserting into DynamoDB: {e}")

        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'POST request received successfully')

with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()