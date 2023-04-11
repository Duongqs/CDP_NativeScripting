utxoin="c668035630a38af1935cc637ba8be526a3d9f786756b22cbad10dde3197376de#0"
policyid=$(cat NFTpolicy.id)
address="addr_test1vqw66gv28k5m0rtsvf8q0mhqf53k4jnvkng8ynd2v5kqryqwt23dw"
output="2000000"
tokenname=$(echo -n "CardanoPioner" | xxd -ps | tr -d '\n')
tokenammount="1"
collateral="c668035630a38af1935cc637ba8be526a3d9f786756b22cbad10dde3197376de#0"
signerPKH="697a501b7d05766b3d08e39dab43e0f170973d3398b28745b3b8ce55"


cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 2 \
  --tx-in $utxoin \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $nami+$output+"900 $policyid.$tokenname" \
  --change-address $nami \
  --mint "$tokenammount $policyid.$tokenname" \
  --mint-script-file policy.script \
  --invalid-before 12537288 \
  --protocol-params-file protocol.params \
  --out-file sminting.unsigned

cardano-cli transaction sign \
  --tx-body-file sminting.unsigned \
  --signing-key-file ../Wallet/Adr01.skey \
  --signing-key-file ../Wallet/Adr07.skey \
  --testnet-magic 2 \
  --out-file sminting.signed

 cardano-cli transaction submit \
  --testnet-magic 2 \
  --tx-file sminting.signed