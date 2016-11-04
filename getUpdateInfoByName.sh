#! /bin/bash

if [ "$#" = 0 ]; then
	echo -e "Usage: ./[script] key\n"
	echo -e "\tSave your Bugly cookie to 'cookie' file to use to request"
	echo -e "\tAnd place you appid at the second line\n"
	exit
fi

key=$2

if [ "$#" = 1 ]; then
	appid=`tail -n 1 cookie`
	key=$1
fi

cookie=`head -n 1 cookie`

jq_cmd="jq -C --indent 2 '.upgrade.allUpdate.items[][] | select(.title | test(\"${key}\")) | {title, issuedCount: .dataPo.issuedCount, activeCount: .dataPo.activeCount}'"

curl_cmd="curl 'https://beta.bugly.qq.com/apps/${appid}/allupdate?pid=1' -s -H 'If-None-Match: W/\"12237-iKW9dNivmtEaZiYHh1fjsQ\"' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-GB,en;q=0.8,zh-CN;q=0.6,zh;q=0.4' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cookie: ${cookie}' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed"

eval "$curl_cmd | perl -ne '/window\.__data=(.*?)<\/script>/ and print \$1, \"\n\"' | $jq_cmd" 2>/dev/null