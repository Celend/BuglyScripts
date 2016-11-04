#! /bin/bash
# Edit the jq_cmd to show more fields

if [ "$#" = 0 ]; then
	echo -e "Usage: ./[script] key\n"
	echo -e "\tSave your Bugly cookie to 'cookie' file to use to request"
	echo -e "\tAnd place you appid at the second line\n"
	exit
fi

key=$1
cookie=`sed '1!d' cookie`
appid=`sed '2!d' cookie`

jq_cmd="jq -C --indent 2 '.upgrade.allUpdate.items[][] | select(.title | test(\"${key}\")) | {title, issuedCount: .dataPo.issuedCount, activeCount: .dataPo.activeCount}'"

curl_cmd="curl 'https://beta.bugly.qq.com/apps/${appid}/allupdate?pid=1' -s -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-GB,en;q=0.8,zh-CN;q=0.6,zh;q=0.4' -H 'Upgrade-Insecure-Requests: 1' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cookie: ${cookie}' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed"

eval "$curl_cmd | perl -ne '/window\.__data=(.*?)<\/script>/ and print \$1, \"\n\"' | $jq_cmd" 2>/dev/null