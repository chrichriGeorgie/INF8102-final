import requests
import os
print("Current directory:", os.getcwd())

# Using HTTP URL
url = 'https://changeme'
data = {'message': 'Data test 2'}

try:
    response = requests.post(url, json=data)
    print(response)
    print(response.text)
except requests.exceptions.SSLError as e:
    print(f"SSL Error: {e}")
except Exception as e:
    print(f"Error: {e}")
