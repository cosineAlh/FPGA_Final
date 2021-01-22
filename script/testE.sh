#!/bin/bash

ghdl -a --ieee=synopsys --std=08 ./src/util_package.vhd
ghdl -a --ieee=synopsys --std=08 ./src/functions.vhd

ls ./src/ | while read src_file
do
    if [[ $src_file != util_package.vhd ]] && [[ $src_file != functions.vhd ]]; then
        ghdl -a --ieee=synopsys --std=08 "./src/$src_file"
    fi
done

cp ./sim/encryptor_tb.vhd encryptor_tb.vhd

ghdl -a --ieee=synopsys --std=08 encryptor_tb.vhd
ghdl -e --ieee=synopsys --std=08 encryptor_tb
ghdl -r --ieee=synopsys --std=08 encryptor_tb --ieee-asserts=disable --stop-time=60us 2>&1 | grep -v "simulation finished @*"

