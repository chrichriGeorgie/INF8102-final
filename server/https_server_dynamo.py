import http.server
import socketserver
import boto3
import uuid
import ssl

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table_name = 'INF8102_TP_Final'
partition_key = 'UserId'  # Specify the partition key

# Check if the table already exists, if not, create it
existing_tables = dynamodb.meta.client.list_tables()['TableNames']
if table_name not in existing_tables:
    table = dynamodb.create_table(
        TableName=table_name,
        KeySchema=[
            {
                'AttributeName': partition_key,
                'KeyType': 'HASH'  # 'HASH' means it's the partition key
            },
            {
                'AttributeName': 'EntryID',  # Your existing unique identifier
                'KeyType': 'RANGE'  # 'RANGE' means it's the sort key
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': partition_key,
                'AttributeType': 'S'  # 'S' means string; adjust as needed
            },
            {
                'AttributeName': 'EntryID',
                'AttributeType': 'S'
            }
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        }
    )

    # Wait for the table to be created before using it
    table.meta.client.get_waiter('table_exists').wait(TableName=table_name)
else:
    table = dynamodb.Table(table_name)

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')

        print("Received POST data:", post_data)

        # Insert the received data into DynamoDB
        try:
            # Create a unique ID for each entry
            entry_id = str(uuid.uuid4())
            user_id = str(uuid.uuid4())# Replace with the actual user ID from your data

            response = table.put_item(
                Item={
                    'UserId': user_id,  # Partition key
                    'EntryID': entry_id,  # Sort key
                    'Data': post_data
                }
            )
            print("Data inserted into DynamoDB:", response)
        except Exception as e:
            print(f"Error inserting into DynamoDB: {e}")

        # Respond to the client
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'POST request received successfully')

# HTTPS Server setup
PORT = 8000
httpd = socketserver.TCPServer(("", PORT), MyHandler)

# Set up SSL context
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile='./8102cert.pem', keyfile='./8102key.pem')

httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
print("HTTPS Server serving at port", PORT)
httpd.serve_forever()
