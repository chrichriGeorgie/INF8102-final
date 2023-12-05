#!/bin/bash


requests=1000
time_limit=30
threads=10


function request() {
    curl -v https://euybn4hu7o43xdp67ykmctr2wa0qajtb.lambda-url.us-east-1.on.aws/
}

export -f request

# Executes the requests in parallel
seq $requests | xargs -n1 -P$threads -I{} bash -c 'request'

sleep $time_limit

