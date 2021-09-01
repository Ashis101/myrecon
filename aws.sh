domain=${1}

gau -subs $domain | grep '.js$' >>$domain/aws/vul1.txt
waybackurls $domain | grep '.js$' >>$domain/aws/vul2.txt
subfinder -d $domain -silent |subjs>>$domain/aws/vul3.txt

cat vul1.txt vul2.txt vul3.txt | httpx >>$domain/aws/uniq.txt

## Gathering s3 buckets

cat uniq.txt | xargs -I% bash -c 'curl -sk "%" | grep -w "*.s3.amazonaws.com"' >>$domain/aws/s3_bucket.txt
cat uniq.txt | xargs -I% bash -c 'curl -sk "%" | grep -w "*.s3.us-east-2.amazonaws.com"' >>$domain/aws/s3_bucket.txt
cat uniq.txt | xargs -I% bash -c 'curl -sk "%" | grep -w "s3.amazonaws.com/*"' >>$domain/aws/s3_bucket.txt
cat uniq.txt | xargs -I% bash -c 'curl -sk "%" | grep -w "s3.us-east-2.amazonaws.com/*"' >>$domain/aws/s3_bucket.txt

# filtering name from bucket list
cat s3_bucket.txt | sed 's/s3.amazonaws.com//' >>$domain/aws/bucket_name.txt
cat s3_bucket.txt | sed 's/s3.us-east-2.amazonaws.com//' >>$domain/aws/bucket_name.txt
# cat bucket_name.txt

# using aws cli
# checking read write permission

# cat bucket_name.txt |xargs -I% sh -c 'aws s3 cp test.txt s3://% 2>&1 | grep "upload" && echo " AWS s3 bucket takeover by cli %"'
# cat bucket_name.txt |xargs -I% sh -c 'aws s3 rm test.txt s3://%/test.txt 2>&1 | grep "delete" && echo " AWS s3 bucket takeover by cli %"'



