#!/bin/bash

# send a small amount just to send
#curl --user $rpcuser:$rpcpassword  --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"sendtoaddress\", \"params\": [\"RS7y4zjQtcNv7inZowb8M6bH3ytS1moj9A\", 0.001, \"\", \"\"] }" -H "content-type: text/plain;" http://$komodo_node_ip:$rpcport/

# check for unaddressed records { batches & certificates }
# generate address in subprocess
# fund new wallets that need funding
# wallet maintenance (e.g. consolidate utxos, make sure threshold minimum available for smooth operation)

# TODO integrity issue if batches funded by product journey inputs more than once
# batches getting funded by certificates, locations, dates, IMPORTANT! processing twice a problem.
# certificates are funded wallets, processing twice not ideal, but not an integrity problem.
# batches are paper wallets, processing twice not a problem IF only for updating address data for APIs

#############################
# variables
#############################
BLOCKHASH=${1}
BATCHES_NO_REPEAT_IMPORT_URL=
BATCHES_GET_UNADDRESSED_URL=
BATCHES_UPDATE_BATCH_ADDRESS_URL=
CERTIFICATES_GET_UNADDRESSED_URL=
CERTIFIACTES_UPDATE_CERTIFICATE_ADDRESS_URL=
EXPLORER_1_BASE_URL=
EXPLORER_2_BASE_URL=
INSIGHT_API_GET_ADDRESS_UTXO="insight-api-komodo/addrs/XX_CHECK_ADDRESS_XX/utxo"
INSIGHT_API_BROADCAST_TX="insight-api-komodo/tx/send"

##############################
# note, var substitution for XX_CHECK_ADDRESS_XX 
# ADDRESS_TO_CHECK="MYLO"
# out="${INSIGHT_API_GET_ADDRESS_UTXO/XX_CHECK_ADDRESS_XX/${ADDRESS_TO_CHECK}}"
# echo $out
#############################

#############################
# batch logic
#############################
BATCHES_NOT_PROCESSED=$(curl -s -X GET ${BATCHES_NO_REPEAT_IMPORT_URL})
BATCHES_INTERRUPTED_IMPORT=$(curl -s -X GET ${BATCHES_NO_REPEAT_IMPORT_URL})
BATCHES_WITH_NO_ADDRESS=$(curl -s -X GET ${BATCHES_GET_UNADDRESSED_URL})

# hook-before-processing , create address for the total received data from integration pipeline
# signmessage, genkomodo.php
# update batches-api with "dont-repeat-address"
# send "pre-process" tx to "dont-repeat-address"

# for loop with jq (for each batch with no address do this)
# signmessage(batch_number)
# genkomodo.php for address
# batches don't need funding
# update batches-api with address

# for loop with jq (for each batch with with pre-process tx
# for each input for this batch, generate tx
# electrum-komodo stuff
# signmessage of input
# genkomodo.php to get wif & address
# get utxo for input to send to batch INSIGHT_API_GET_ADDRESS_UTXO
# createrawtransaction funding batch address & sending change back to this (input) address
# use wif in signmessage.py with the utxo
# broadcast via explorer INSIGHT_API_BROADCAST_TX

# hook-after-processing
# send "post-process" tx to "dont-repeat-address"
# address with pre & post process tx 


#############################


############################
# cert logic

