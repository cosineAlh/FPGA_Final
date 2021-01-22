#!/bin/bash

ghdl -a --ieee=synopsys --std=08 ./src/util_package.vhd
ghdl -a --ieee=synopsys --std=08 ./src/functions.vhd

ls ./src/ | while read src_file
do
    if [[ $src_file != util_package.vhd ]] && [[ $src_file != functions.vhd ]]; then
        ghdl -a --ieee=synopsys --std=08 "./src/$src_file"
    fi
done

cp ./sim/decryptor_tb.vhd decryptor_tb.vhd

ghdl -a --ieee=synopsys --std=08 decryptor_tb.vhd
ghdl -e --ieee=synopsys --std=08 decryptor_tb
ghdl -r --ieee=synopsys --std=08 decryptor_tb --ieee-asserts=disable --stop-time=60us 2>&1 | grep -v "simulation finished @*"

