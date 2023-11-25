import requests

url = 'http://localhost:8000'
data = {'message': 'inf8108 c\'est WHATTTT'}
response = requests.post(url, json=data)

print(response.text)