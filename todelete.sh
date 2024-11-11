#! /bin/bash --
# This script processes the output from below kibana query 
#
# GET campaign-root/_search
# {
#   "size": 100,
#   "query" : {
#     "term" : {
#       "campaign.marketplaceId": "ATVPDKIKX0DER"
#     }
#   },
#   "sort": [
#     {"_id":{"order": "asc"}}
#   ]
# }

set -e 
trap 'rm id.txt routing.txt &> /dev/null' EXIT HUP INT PIPE QUIT TERM

cat $1 | grep -E '_id'      | cut -d: -f2 | tr '",' ' ' | tr -d ' ' > id.txt
cat $1 | grep -E '_routing' | cut -d: -f2 | tr '",' ' ' | tr -d ' ' > routing.txt

> todelete.txt 
while read -r id && read -r routing <&3 ; do 
    echo "DELETE campaign-root/_doc/$id?routing=$routing" >> todelete.txt 
    echo "{}" >> todelete.txt
done < id.txt 3< routing.txt 
