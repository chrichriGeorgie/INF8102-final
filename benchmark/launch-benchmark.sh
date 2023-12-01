#!/bin/bash

nmap_name="nmap"
masscan_name="masscan"
hydra_name="hydra"

echo "Automated script to benchmark EC2 Command-And-Control project on AWS."
echo "Verifying if necessary tools are installed."
echo "Verifying if nmap is installed"

if command -v "$nmap_name" >/dev/null 2>&1; then
    echo "nmap is installed"
else
    echo "nmap does not seem to be installed. Please install nmap and run this program again".
    exit 1
fi

echo "Verifying if masscan is installed"

if command -v "$masscan_name" >/dev/null 2>&1; then
    echo "masscan is installed"
else
    echo "masscan does not seem to be installed. Please install masscan and run this program again".
    exit 1
fi

echo "Verifying if hydra-gtk is installed"

if command -v "$hydra_name" >/dev/null 2>&1; then
    echo "hydra is installed"
else
    echo "hydra does not seem to be installed. Please install hydra and run this program again".
    exit 1
fi

echo "A specific github package is required for DoS attack simulation. Do you wish to download it? [y/N]"
read -r response


if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "You chose to continue. Downloading from https://github.com/Leeon123/Stress-tester"
    command_to_run="ls"
    $command_to_run > /dev/null 2>&1
    exit_status=$?

    if [ $exit_status -eq 0 ]; then
        echo "Command executed successfully."
    else
        echo "Command failed with exit status $exit_status."
    fi

fi

echo "Please specify IPv4 address to test (XXX.XXX.XXX.XXX)"
read -r ip

# Nmap
echo "Running nmap for Reconnaissance"
sudo nmap -sV -O $ip -Pn > nmap.txt
echo "Results:"
cat nmap.txt

# Masscan
echo "Running masscan for Reconnaissance"
sudo masscan -p 1-1000 $ip --banner --output-format json -oX masscan.json

# hydra-gtk
echo "Running hydra to try and bruteforce SSH password connection"
echo "You have to place a file named users.txt and dict.txt to use for bruteforce"
echo "Have you provided these files? [y/N]"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "You have provided the files."
    hydra -L users.txt -P dict.txt $ip ssh -t 4
    exit_status=$?

    if [ $exit_status -eq 0 ]; then
        echo "Command executed successfully."
    else
        echo "[Problem with hydra] Continuing."
    fi
else
    echo "Cannot continue. Goodbye."
    exit 0
fi

echo "This next attack is not mandatory. It is a simulation of denial of service."
echo "If you understand the implications, do you want to proceed? [y/N]"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "You chose to continue. Using Stress-tester."
    echo "Specify the tcp port to test"
    read -r port
    go build Stress-tester/stress.go 
    ./Stress-tester/stress $ip $port 1 1000 30 5
    exit_status=$?

    if [ $exit_status -eq 0 ]; then
        echo "Command executed successfully."
    else
        echo "Command failed with exit status $exit_status."
    fi

fi

echo "Benchmark complete. Goodbye."
exit 0
