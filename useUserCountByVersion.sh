#! /bin/bash
# Get total use user count of specified version in today

if [ "$#" = 0 ]; then
	echo -e "Usage: ./[script] version [dayOffset]"
	echo -e "\tdayOffset:\t\t0: today, 1: yesterday..."
	echo -e "\tSave your Bugly cookie to 'cookie' file to use to request"
	echo -e "\tAnd place you appid at the second line\n"
	exit
fi

version=$1
cookie=`sed '1!d' cookie`
appid=`sed '2!d' cookie`
dayOffset=0

format='%Y%m%d'
baseDate=`date +"$format"`

if [ "$#" -gt 1 ]; then
	dayOffset=$2
	baseDate=`date -v -${dayOffset}d -jf $format $baseDate +"$format"`
fi

startTime="${baseDate}00"
endTime="${baseDate}23"
token=`python3 generate_token.py "$cookie"`

curl_cmd="curl 'https://bugly.qq.com/v2/appId/${appid}/pid/1/version/${version}/channel/-1/startHour/${startTime}/endHour/${endTime}/getOperateRealtimeAppendTrend' -s -H 'X-token: ${token}' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-GB,en;q=0.8,zh-CN;q=0.6,zh;q=0.4' -H 'content-type: application/json;charset=utf-8' -H 'accept: application/json;charset=utf-8' -H 'Cookie: ${cookie}' -H 'Connection: keep-alive' --compressed"

eval "$curl_cmd | jq '.ret.data.dataList | map(select(.useUserAmount > 0))[-1] | {useUserAmount, startUpAmount}'"
