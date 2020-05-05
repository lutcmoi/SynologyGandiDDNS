#!/bin/bash
set -e;

ipv4Regex="((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])"

proxy="true"

dnsProviderUrl="https://dns.api.gandi.net/api/v5/domains"

# DSM Config
username="$1"
password="$2"
hostname="$3"
ipAddr="$4"

if [[ $ipAddr =~ $ipv4Regex ]]; then
    recordType="A";
else
    recordType="AAAA";
fi

IFS='.' read -ra ADDR <<< ${hostname}

listDnsApi="${dnsProviderUrl}/${ADDR[1]}.${ADDR[2]}/records/${ADDR[0]}/${recordType}"
createDnsApi="${dnsProviderUrl}/${ADDR[1]}.${ADDR[2]}/records"

res=$(curl -s -X GET "$listDnsApi" -H "X-Api-Key: $password" -H "Content-Type:application/json")
resCode=$(echo "$res" | jq -r ".code")
resRecord=$(echo "$res" | jq -r ".rrset_values")

existingRecord="true"
if [[ $resCode == "404" ]]; then
	existingRecord="false";
elif [[ -z $resRecord ]]; then
    echo "badauth";
    exit 1;
fi

if [[ $recordIp = "$ipAddr" ]]; then
    echo "nochg";
    exit 0;
fi

if [[ $existingRecord = "false" ]]; then
    # Record not exists	
	res=$(curl -s -X POST "$createDnsApi" -H "X-Api-Key: $password" -H "Content-Type:application/json" --data "{\"rrset_type\":\"$recordType\",\"rrset_ttl\":10800,\"rrset_name\":\"$ADDR[0]\",\"rrset_values\": [\"$ipAddr\"]}")
else
    # Record exists
    res=$(curl -D- -XPUT "$listDnsApi" -H "X-Api-Key: $password" -H "Content-Type: application/json" --data "{\"rrset_values\": [\"$ipAddr\"]}")
fi

resSuccess=$(echo "$res" | grep "Created")

if [[ -z $resSuccess ]]; then
	echo "badauth";
else
    echo "good";
fi
