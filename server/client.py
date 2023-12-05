import requests
import os
print("Current directory:", os.getcwd())

# Using HTTP URL
url = 'https://d5zeahzi7qqurpjc3phwqoqnli0wcsby.lambda-url.us-east-1.on.aws/'
data = {'message': 'Data test 2'}

try:
    response = requests.post(url, json=data)
    print(response)
    print(response.text)
except requests.exceptions.SSLError as e:
    print(f"SSL Error: {e}")
except Exception as e:
    print(f"Error: {e}")
