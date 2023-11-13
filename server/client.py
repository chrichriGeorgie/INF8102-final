import requests

url = 'http://localhost:8000'
data = {'message': 'Hello, World'}
response = requests.post(url, json=data)

print(response.text)