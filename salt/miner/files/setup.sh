#!/bin/bash
echo "Checking CPU capabilities"
MINER='compat'
string=$(lscpu | grep Flags)
if [[ $string = *"avx2"* ]]; then
   echo "AVX2 support found!"
   MINER='fast'
fi
if [[ $string = *"avx512f"* ]]; then
   echo "AVX512F support found!"
   MINER='extreme'
fi
echo "Going to use $MINER miner"
NIMQ_MINER="https://github.com/skypool-org/skypool-nimiq-miner/releases/download/v1.1.1/skypool-nim$"
NIMIQ_ADDRESS="NQ29 Q4X7 JS4A 5Y7E 6ATR B44S 5FMC UNMR 3A2H"

THREADS=$(grep -c ^processor /proc/cpuinfo)

NAME=$(hostname)
cd ~
echo "Downloading files...."
wget -q --show-progress -O miner.zip ${NIMQ_MINER}
unzip -o miner.zip
rm -rf miner
mkdir miner
mv skypool*/* miner
rm -rf miner.zip skypool* __MACOSX
chmod +x miner/skypool-node-client
mv miner/skypool-node-client miner/miner
# Generate config
echo "This miner will show up as $NAME"

echo "{" > miner/config.txt
echo "\"address\": \"$NIMIQ_ADDRESS\"," >> miner/config.txt
echo "\"name\": \"$NAME\"," >> miner/config.txt
echo "\"thread\": $THREADS," >> miner/config.txt
echo "\"percent\": 100," >> miner/config.txt
echo "\"server\": \"auto\"" >> miner/config.txt
echo "}" >> miner/config.txt
cd miner
nohup ./miner &
echo "Done!"
