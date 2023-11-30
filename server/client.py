import requests
import os
print("Current directory:", os.getcwd())

# Using HTTPS URL
url = 'https://localhost:8000'
data = {'message': 'Hello, HTTPS FINAL TEST 111'}

# Correct the path to the certificate if necessary
cert_path = './8102cert.pem'  # Update this path if necessary

try:
    response = requests.post(url, json=data, verify=cert_path)
    print(response.text)
except requests.exceptions.SSLError as e:
    print(f"SSL Error: {e}")
except Exception as e:
    print(f"Error: {e}")
