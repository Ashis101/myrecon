
echo "-----GitDork-Starting------"
domains=${1}
organisation=${2}

# gitdorker -org organisation  -d /home/ashis/Documents/scripts/GitDorker/Dorks/medium_dorks.txt  -tf /home/ashis/Documents/scripts/GitDorker/tf/TOKENSFILE  -pf -p -ri  -o gitsec.txt
gitdorker -qf $domains/domain.txt  -d /home/ashis/Documents/scripts/GitDorker/Dorks/medium_dorks.txt  -tf /home/ashis/Documents/scripts/GitDorker/tf/TOKENSFILE  -pf -p -ri  -o $domain/gitsec

# gitdorker -org etsy  -d /home/ashis/Documents/scripts/GitDorker/Dorks/medium_dorks.txt  -tf /home/ashis/Documents/scripts/GitDorker/tf/TOKENSFILE  -pf -p -ri  -o gitsec.txt
# gitdorker -org etsy  -d /home/ashis/Documents/scripts/GitDorker/Dorks/medium_dorks.txt  -tf /home/ashis/Documents/scripts/GitDorker/tf/TOKENSFILE  -pf -p -ri  -o gitsec.txt
