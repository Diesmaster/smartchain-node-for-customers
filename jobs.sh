#!/bin/bash
# we send this amount to an address for house-keeping
# update by 0.0001 (manually, if can be done in CI/CD, nice-to-have not need-to-have) (MYLO)
# house keeping address is list.json last entry during dev
SCRIPT_VERSION=0.0011
HOUSE_KEEPING_ADDRESS="RS7y4zjQtcNv7inZowb8M6bH3ytS1moj9A"

# send a small amount (SCRIPT_VERSION) for HOUSE_KEEPING_ADDRESS from each organization, TODO modulo block number (MYLO)
#############################
# one explorer url to check is
# IJUICE  http://seed.juicydev.coingateways.com:24711/address/RS7y4zjQtcNv7inZowb8M6bH3ytS1moj9A
# POS95   http://seed.juicydev.coingateways.com:54343/address/RS7y4zjQtcNv7inZowb8M6bH3ytS1moj9A
#############################
# initial send 0.001, works
# curl --user $rpcuser:$rpcpassword  --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"sendtoaddress\", \"params\": [\"RS7y4zjQtcNv7inZowb8M6bH3ytS1moj9A\", 0.001, \"\", \"\"] }" -H "content-type: text/plain;" http://$komodo_node_ip:$rpcport/
# update to send SCRIPT_VERSION, increment by 0.0001 for each update
# TODO check with vic about variables passed in, or can source from config file (but config file requires generation from docker-compose runtime params)
curl --user $rpcuser:$rpcpassword  --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"sendtoaddress\", \"params\": [\"${HOUSE_KEEPING_ADDRESS}\", ${SCRIPT_VERSION}, \"\", \"\"] }" -H "content-type: text/plain;" http://$komodo_node_ip:$rpcport/
curl --user $RPC_USER:$RPC_PASSWORD --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"sendtoaddress\", \"params\": [\"${HOUSE_KEEPING_ADDRESS}\", ${SCRIPT_VERSION}, \"\", \"\"] }" -H "content-type: text/plain;" http://$komodo_node_ip:$RPC_PORT/
#############################

# general flow (high level)
#############################
# check for unprocessed imports (import api)
# check for imports with address but no pre-process tx (indicates something wrong with rpc to signmessage or php address-gen)
# check for imports with address but no post-process tx (indicates incomplete import, potential rpc error)
# check for unaddressed records { certificates, facilities, country etc. }
# generate address in subprocess
# fund new wallets that need funding
# wallet maintenance (e.g. consolidate utxos, make sure threshold minimum available for smooth operation)
#############################

# TODO IMPORTANT! integrity issue if batches funded by product journey inputs more than once
# batches getting funded by certificates, locations, dates, IMPORTANT! processing twice a problem. (MYLO)
# certificates are funded wallets, processing twice not ideal, but not an integrity problem.
# batches are paper wallets, processing twice not a problem IF only for updating address data for APIs

#############################
# variables v1
# IMPORTANT! can add, but do not change names until v2 is sanctioned by vic/CI/CD team (MYLO)
#############################
BLOCKHASH=${1}
BATCHES_NO_REPEAT_IMPORT_URL=
BATCHES_GET_UNADDRESSED_URL=
BATCHES_UPDATE_BATCH_ADDRESS_URL=
CERTIFICATES_GET_UNADDRESSED_URL=
CERTIFIACTES_UPDATE_CERTIFICATE_ADDRESS_URL=
CERTIFICATES_NO_FUNDING_TX_URL=
EXPLORER_1_BASE_URL=
EXPLORER_2_BASE_URL=
INSIGHT_API_GET_ADDRESS_UTXO="insight-api-komodo/addrs/XX_CHECK_ADDRESS_XX/utxo"
INSIGHT_API_BROADCAST_TX="insight-api-komodo/tx/send"
IMPORT_API_BASE_URL=
JUICYCHAIN_API_BASE_URL=

##############################
# note, var substitution for XX_CHECK_ADDRESS_XX 
# ADDRESS_TO_CHECK="MYLO"
# out="${INSIGHT_API_GET_ADDRESS_UTXO/XX_CHECK_ADDRESS_XX/${ADDRESS_TO_CHECK}}"
# echo $out
#############################

# house keeping
#############################
# get the block height this blocknotify is running,send to api/db/reporting TODO finalize these vars with vic (MYLO)
#BLOCKHEIGHT=$(curl -s --user $rpcuser:$rpcpassword --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"getblock\", \"params\": [\"${BLOCKHASH}\"] }" -H 'content-type: text/plain;' http://$komodo_node_ip:$rpcport/ | jq -r '.result.height')

#############################
# batch logic
#############################
# receive json responses
BATCHES_IMPORT_NEW_NO_ADDRESS=$(curl -s -X GET ${BATCHES_NO_REPEAT_IMPORT_URL})
BATCHES_IMPORT_NO_POST_PROCESS_TX=$(curl -s -X GET ${BATCHES_NO_REPEAT_IMPORT_URL})
BATCHES_WITH_NO_ADDRESS=$(curl -s -X GET ${BATCHES_GET_UNADDRESSED_URL})

# hook-before-processing , create address for the import data from integration pipeline
# signmessage, genkomodo.php
# update batches-api with "import-address"
# send "pre-process" tx to "import-address"

# for loop with jq (for each batch with no address do this)
# signmessage(batch_number)
# genkomodo.php for address
# batches don't need funding
# update batches-import-api with address
# update juicychain-api with batch address
# TODO check juicychain-api for required product-journey addresses (MYLO)

# TODO for loop with jq (for each batch with with pre-process tx (not conceived properly yet) (MYLO)
# for each input for this batch, generate tx
# electrum-komodo stuff
# signmessage of input
# genkomodo.php to get wif & address
# get utxo for input to send to batch INSIGHT_API_GET_ADDRESS_UTXO
# createrawtransaction funding batch address & sending change back to this (input) address
# use wif in signmessage.py with the utxo
# broadcast via explorer INSIGHT_API_BROADCAST_TX

# hook-after-processing
# send "post-process" tx to "import-address"
# "import-address" with pre & post process tx


#############################


############################
# cert logic

CERTIFICATES_NEW_NO_ADDRESS=$(curl -s -X GET ${CERTIFICATES_GET_UNADDRESSED_URL})
CERTIFICATES_NO_FUNDING_TX=$(curl -s -X GET ${CERTIFICATES_GET_NO_FUNDING_TX_URL})

# for loop with jq (for each certificate with no address do this)
# signmessage(cert_identifier)
# genkomodo.php for address
# update juicychain-api with address
# certificates need funding, rpc sendtoaddress
# update juicychain-api with funding tx (separate to address-gen update, possibly no funds to send)
