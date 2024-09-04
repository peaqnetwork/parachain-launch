current_dec=9
current_hex=$(printf "0x%X" "$current_dec")

curl -s http://127.0.0.1:20044 -H "Content-Type:application/json;charset=utf-8" -d \
  '{
      "jsonrpc": "2.0",
      "id": 1,
      "method": "debug_traceBlockByNumber",
      "params": ["'"${current_hex}"'", {"tracer": "callTracer"}]
  }'  | jq '.result'


 curl -s http://127.0.0.1:20044 -H "Content-Type:application/json;charset=utf-8" -d \
   '{
       "jsonrpc": "2.0",
       "id": 1,
       "method": "debug_traceBlockByNumber",
       "params": ["'"${current_hex}"'", {"tracer": "callTracer"}]
   }' | jq '.result'
