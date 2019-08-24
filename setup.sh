#!/bin/bash

sudo apt-get -y update
sudo apt-get -y upgrade

# Pulling down bashrc & bash_aliases
echo "Pulling bashrc and bash_aliases from Github..."
git clone https://github.com/Cymricz/bash_profile.git
cd bash_profile
cat .bashrc >> ~/.bashrc
cat .bash_aliases >> ~/.bash_aliases
source ~/.bashrc
cd ~/tools/
echo "Done."

# Install Go
if [[ -z "$GOPATH" ]];then
echo "Looks like Go isn't installed, would you like to install it now?"
PS3="Please select an option: "
choices=("yes" "no")
select choice in "${choices[@]}"; do
	case $choice in
		yes)
			echo "Installing Golang"
			wget https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz
			sudo tar -xvf go1.12.9.linux-amd64.tar.gz
			sudo mv go /usr/local
			export GOROOT=/usr/local/go
			export GOPATH=$HOME/go
			export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
			echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
			echo 'export GOPATH=$HOME/go' >> ~/.bashrc
			echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bashrc
			source ~/.bashrc
			sleep 1
			break
			;;
		no)
			echo "Please install Go and re-run this script"
			echo "Aborting installation..."
			exit 1
			;;
	esac
done
fi

# Package-managed tools
sudo apt-get install -y python3
sudo apt-get install -t python3-pip
sudo apt-get install -y Sublist3r
sudo apt-get install -y nmap
sudo apt-get install -y nc

# Create tools directory
mkdir ~/tools
cd ~/tools/

# Git tools
echo "Installing dirsearch..."
git clone https://github.com/maurosoria/dirsearch.git
cd ~/tools/
echo "Done."

echo "Installing Amass..."
go get -u github.com/OWASP/Amass
echo "Done."

echo "Installing httprobe..."
go get -u github.com/tomnomnom/httprobe
echo "Done."

echo "Pulling down Seclists..."
cd ~/tools/
git clone https://github.com/danielmiessler/SecLists.git
cd ~/tools/SecLists/Discovery/DCS/
## This file breaks MassDNS (which I don't use currently :p) and needs to be cleaned.
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
cd ~/tools/
echo "Done."
