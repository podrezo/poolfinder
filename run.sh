export FIRESTORE_PROJECT="poolfinder-2679b"
export FIRESTORE_KEYFILE="$(pwd)/key.json"

pushd ./dataloader/lib
ruby run.rb
popd