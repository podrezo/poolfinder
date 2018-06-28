export FIRESTORE_PROJECT="poolfinder-2679b"
export FIRESTORE_KEYFILE="$(pwd)/key.json"

pushd ./dataloader/lib &> /dev/null
ruby run.rb
popd &> /dev/null