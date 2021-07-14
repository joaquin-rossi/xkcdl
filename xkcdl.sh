#!/bin/sh
website='https://xkcd.com'
timeout=1
list=''

usage()
{
	cat <<- EOF
	usage: xkcdl [-h] [-l] [-n NUM] [-a] [-t TIME]
	arguments:
	    -h        show this help message and exit
	    -l        download latest comic
	    -n NUM    download comic specified by number
	    -a        download all comics
	    -t TIME   set timeout between downloads
	EOF
}

download()
{
    url=$(curl -Ls "${website}/${1}/info.0.json" | jq '.img' | sed 's/"//g')
    curl -Lso "${1}.${url##*.}" "${url}"
    echo "xkcd #${1} from '${url}' downloaded"
}

latest()
{
    curl -s "${website}/info.0.json" | jq '.num'
}

while getopts 'ht:ln:a' flag
do
    case "$flag"
    in
        h) usage; exit;;

        t) timeout="${OPTARG}";;

        l) list="${list}:$(latest)";;
        n) list="${list}:${OPTARG}";;
        a) for i in $(seq "$(latest)"); do list="${list}:${i}"; done;;
	
	*) usage; exit;;
    esac
done

[ -z "$list" ] && (usage ; exit)

for i in $(echo "$list" | sed 's/:/\n/g')
do
    download "$i"
    sleep "$timeout"
done
