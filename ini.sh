#!/bin/bash

# Nama file miner
MINER_FILE="iniminer-linux-x64"
DOWNLOAD_URL="https://github.com/Project-InitVerse/miner/releases/download/v1.0.0/$MINER_FILE"

# Cek apakah file miner sudah ada
if [ ! -f "$MINER_FILE" ]; then
    echo "File miner tidak ditemukan, mengunduh..."
    wget "$DOWNLOAD_URL"
    
    # Pastikan file berhasil diunduh
    if [ $? -ne 0 ]; then
        echo "Gagal mengunduh miner. Periksa koneksi internet Anda."
        exit 1
    fi
fi

# Berikan izin eksekusi
chmod +x "$MINER_FILE"

# Meminta input dari user
read -p "Masukkan alamat wallet Anda: " WALLET
read -p "Masukkan nama worker: " WORKER
read -p "Batasi jumlah CPU? (y/n): " LIMIT_CPU

CPU_DEVICES=""
if [[ "$LIMIT_CPU" == "y" || "$LIMIT_CPU" == "Y" ]]; then
    read -p "Masukkan jumlah CPU yang ingin digunakan: " CPU_COUNT
    for ((i=0; i<CPU_COUNT; i++)); do
        CPU_DEVICES+=" --cpu-devices $i"
    done
fi

# Jalankan miner dengan parameter yang telah disusun
./$MINER_FILE --pool stratum+tcp://$WALLET.$WORKER@pool-core-testnet.inichain.com:32672 $CPU_DEVICES
