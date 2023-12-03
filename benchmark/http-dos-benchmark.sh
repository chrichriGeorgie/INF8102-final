#!/bin/bash

# Define the number of requests and the time limit
requests=1000
time_limit=30

# Define the number of threads to use
threads=1

# Define the URL to request
url="https://euybn4hu7o43xdp67ykmctr2wa0qajtb.lambda-url.us-east-1.on.aws/"

# Define the function to execute in parallel
function request() {
    curl -v "$url" > /dev/null
}

export -f request

# Execute the requests in parallel
seq $requests | xargs -n1 -P$threads -I{} bash -c 'request'

# Wait for the time limit to expire
sleep $time_limit

