#!/bin/sh
url='https://xkcd.com'
timeout=1

usage()
{
cat << EOF
usage: xkcdl [-h] [-l] [-d NUM] [-a]
arguments:
    -h          show this help message and exit
    -n NUM      download specified comic by number
    -l          download latest comic
    -a          download all comics
    -t TIME     set timeout (low timeouts may get you banned)
EOF
}

download()
{
    image=$(curl -Ls "$url/$1/" | grep "URL" | awk '{print $5}')
    curl -Lso "$1"."${image##*.}" "$image"
    echo "xkcd #$1 from $image downloaded"
}

latest()
{
    prev=$(curl -Ls "$url" | grep "prev" | head -n 1 | awk '{print $3}' | grep -Eo '[0-9]+')
    echo $((prev+1))
}

while getopts 'ht:n:la' flag
do
    case "$flag"
    in
        h) usage; exit;;

        t) timeout="${OPTARG}";;

        n) download "${OPTARG}"; exit;;
        l) download "$(latest)"; exit;;
        a) for i in $(seq "$(latest)"); do download "$i" && sleep "$timeout"; done; exit;;

        *) exit;;
    esac
done

usage
