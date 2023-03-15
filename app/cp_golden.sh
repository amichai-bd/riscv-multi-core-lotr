!/bin/bash

source_dir="target/lotr/tests/"
dest_dir="verif/lotr/golden_trk/"

for dir in "${source_dir}"*/; do
    name=$(basename "${dir}")
    cp "${dir}trk_RC_transactions.log" "${dest_dir}golden_${name}_trk_RC_transactions.log"
done


source_dir="target/gpc_4t/tests/"
dest_dir="verif/gpc_4t/golden_trk/"

for dir in "${source_dir}"*/; do
    name=$(basename "${dir}")
    cp "${dir}shrd_mem_snapshot.log" "${dest_dir}golden_${name}_shrd_mem_snapshot.log"
done
