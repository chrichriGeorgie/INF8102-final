import requests

url = 'http://localhost:8000'
data = {'message': 'we teh team, celina!'}
response = requests.post(url, json=data)

print(response.text)