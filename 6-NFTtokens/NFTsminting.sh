utxoin="c668035630a38af1935cc637ba8be526a3d9f786756b22cbad10dde3197376de#0"
policyid=$(cat NFTpolicy.id)
nami_address="addr_test1qz50c8fgdlk9nafppmlzdu6nr8fzpzzgp4vl7l5dvt95lcl4qx6ehrzfcm7cu78gymeqxtzemw9txrgywk0m0qcxux4qm3fx2d"
output="2000000"
tokenname=$(echo -n "CardanoPioner" | xxd -ps | tr -d '\n')
tokenammount="1"
collateral="c668035630a38af1935cc637ba8be526a3d9f786756b22cbad10dde3197376de#0"
signerPKH="183888124b2be0d8129326d25d8ad3ff207e80c8cc8bc9473e539870"


cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 2 \
  --tx-in $utxoin \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $nami_address+$output+"$tokenammount $policyid.$tokenname" \
  --change-address $nami_address \
  --mint "$tokenammount $policyid.$tokenname" \
  --mint-script-file NFTpolicy.script \
  --invalid-before 14596918 \
  --metadata-json-file NFTmetadata.json \
  --protocol-params-file protocol.params \
  --out-file NFTsminting.unsigned

cardano-cli transaction sign \
  --tx-body-file NFTsminting.unsigned \
  --signing-key-file /config/workspace/repo/Wallet/Adr1.skey \
  --signing-key-file /config/workspace/repo/Wallet/Adr2.skey \
  --testnet-magic 2 \
  --out-file NFTsminting.signed

 cardano-cli transaction submit \
  --testnet-magic 2 \
  --tx-file NFTsminting.signed