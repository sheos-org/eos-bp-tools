#!/bin/bash
# Script to send email alert if the claimrewards period is more than 86520. Put in your crontab and run it every 10 minutes. It will send an email each time that the claim time is greater than 24 hours + 2 minutes.
# Update these params for your system
API="https://proxy.eosnode.tools"
PRODUCER="<ENTER PRODUCER NAME>"
EMAIL="<ENTER DESTINATION EMAIL>"

# Do not modify these unless you know what you're changing.
LAST_CLAIM=$(curl -sX POST "$API/v1/chain/get_table_rows" -d '{"scope":"eosio", "code":"eosio", "table":"producers", "json":true, "limit":10000}' | jq --arg prd "$PRODUCER" -r '.rows[] | select(.owner==$prd) | .last_claim_time')
CLAIM_TIME=$(date -d "$LAST_CLAIM" +"%s")
NOW=$(date +"%s")
DIFF="$(($NOW-$CLAIM_TIME))"
DIFF_CHECK=86520
DELAY=$(($DIFF / 60))

if [ $DIFF > $DIFF_CHECK ]; then
    echo "No rewards have been claimed in $DELAY minutes. Please check the bpvip server." | mail -s "EOS CLAIMREWARDS ISSUE" $EMAIL
    exit 1
fi
