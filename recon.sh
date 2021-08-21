#!/bin/bash

# subdomain enumeration(domain info,only domian)
# test subdomain takover
# all url 
# only javascript file
# nmap scan 
# eyewitness



domain=${1}
dir=$domain
x=0
y=0


if $domain 
then
    clear
    echo "Usage: ./test.sh <domain> "
    exit 1
fi

if [ ! -d $dir ]
then
    mkdir $dir
    cd $dir
else
    clear
    echo " ---------Directory Exists-------- "
    exit 1
fi


while [[ $x -le 1 ]]
do  
    if [[ $x == 1 ]]
    then
        echo "useing httpsx "
        subfinder -d $domain  | httpx -title -tech-detect -status-code -follow-redirects >> domain-info.txt 
    else
        echo "using normal "
        subfinder -d $domain | httpx -mc 200  >> domain.txt

    fi

    ((x=x+1))


done

echo " Subdomain Enumeration Completed.........."
echo " Testing On Subdomain Takeover.........."

subzy -hide_fails -targets=domain.txt >> sbtk.txt
 
echo " Gatering all urls of all domain.........."
gau -o all-domian-url.txt  -subs $domain 

echo " Gathering single domain url "
echo " Making Final Urls List and javascript file list to js directory.........."

while read line
do
    mkdir $line
    gau $line >> $line/gau-url.txt
    waybackurls $line >> $line/way-url.txt
    cd $line && cat gau-url.txt way-url.txt | sort -u | httpx -mc 200 >> final-url.txt
    mkdir js
    cat final-url.txt | grep '.js$' >> js/js.txt
    cd ..

    # echo $line
done < domain.txt
echo " Gathering Eyewitness.......... "

mkdir eyewitnes
eyewitness --web --delay 5  --timeout 30 --no-prompt -f $(pwd)/domain.txt  -d $(pwd)/eyewitness 

# echo " Starting Nmap Scan................ "
nmap -sV -iL subdomains.txt -oN scaned-port.txt 
nmap -sV -iL subdomains.txt -oN scaned-port-vuln.txt --script=vuln


echo "Starting Nuclie Scan (cves,exposed-panel,misconfig,technology,vulnerability,file).........."

# Updating Nuclie Templete


# while read line
# do
#     nuclei -u $line -t cves/ -o $line/scan-cves.txt
#     nuclei -u $line -t exposed/ -o $line/scan-exposed.txt
#     nuclei -u $line -t misconfig/ -o $line/scan-miscon.txt
#     nuclei -u $line -t technology/ -o $line/scan-tech.txt
#     nuclei -u $line -t vulnerability/ -o $line/scan-vuln.txt
#     nuclei -u $line -t file/ -o $line/scan-file.txt
# done < domain.txt



echo "-----Scans Are Completed------"
