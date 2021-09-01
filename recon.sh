#!/bin/bash

# subdomain enumeration(domain info,only domian) subfinder
# test subdomain takover subzy 
# all url (gau , waybackurls)
# only javascript file 
# nmap scan (namp)
# eyewitness (eyewitness)
# caracters filter (kxss)


org=${2}
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
        subfinder -d $domain  | httpx -title -tech-detect -status-code -follow-redirects >> domain-info.txt 
    else
        subfinder -d $domain  >> domain.txt


    fi

    ((x=x+1))


done




echo " Subdomain Enumeration Completed.........."
echo " Testing On Subdomain Takeover.........."

subzy -hide_fails -targets=domain.txt >> sbtk.txt
 
echo " Gatering all urls of all domain.........."
gau -o all-domian-url.txt  -subs $domain 

./gitdork.sh $domain $org
./aws.sh $domain

echo " Gathering single domain url "
echo " Making Final Urls List and javascript file list to js directory.........."

while read line
do
    mkdir $line
    gau $line >> $line/gau-url.txt
    waybackurls $line >> $line/way-url.txt
    cd $line && cat gau-url.txt way-url.txt | sort -u | httpx >> final-url.txt
    
    mkdir xssred
    
    cat final-url| sort -u | gf xss >> xssred/xred.txt
    cat final-url | sort -u | gf redirect >> xssred/xred.txt
    cat xssred/xred | sort -u | kxss >> xssred/xssfill.txt

    mkdir ssrf 
    cat final-url |sort-u| gf ssrf >>ssrf/ssrf

    mkdir js
    cat final-url.txt | grep '.js$' >> js/js.txt
    cat final-url.txt | grep '.json$' >> json/json.txt

    dalfox file xssred/xred.txt pipe -o dalxss.txt
    cd ..

    # echo $line
done < domain.txt

echo " Gathering Eyewitness.......... "

eyewitness --web --delay 5  --timeout 30 --no-prompt -f $(pwd)/domain.txt  -d $(pwd)/eyewitness 

# echo " Starting Nmap Scan................ "

nmap -sV -iL domain.txt -oN scaned-port.txt 
nmap -sV -sC -iL domain.txt -oN scaned-port-vuln.txt --script=vuln


echo "-----Scans Are Completed------"
