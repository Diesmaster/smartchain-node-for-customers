#!/bin/bash
#curl --user $rpcuser:$rpcpassword  --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "sendtoaddress", "params": ["RS7y4zjQtcNv7inZowb8M6bH3ytS1moj9A", 0.001, "", ""] }' -H 'content-type: text/plain;' http://$komodo_node_ip:$rpcport/
curl --user $rpcuser:$rpcpassword  --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"sendtoaddress\", \"params\": [\"RS7y4zjQtcNv7inZowb8M6bH3ytS1moj9A\", 0.001, \"\", \"\"] }" -H "content-type: text/plain;" http://$komodo_node_ip:$rpcport/
#curl --user $rpcuser:$rpcpassword  --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"sendtoaddress\", \"params\": [\"$customer_test_address\", 0.001, \"\", \"\"] }" -H "content-type: text/plain;" http://$komodo_node_ip:$rpcport/
