import requests

url = 'http://localhost:8000'
data = {'message': 'inf8102 cest chaud'}
response = requests.post(url, json=data)

print(response.text)
