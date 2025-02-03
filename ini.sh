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

# Menampilkan daftar pool
echo "Pilih pool yang ingin digunakan:"
echo "1. pool-a.yatespool.com:31588"
echo "2. pool-b.yatespool.com:32488"
read -p "Masukkan nomor pool (1/2): " POOL_CHOICE

# Validasi input pool
while [[ "$POOL_CHOICE" != "1" && "$POOL_CHOICE" != "2" ]]; do
    echo "Pilihan tidak valid. Silakan masukkan 1 atau 2."
    read -p "Masukkan nomor pool (1/2): " POOL_CHOICE
done

# Menentukan alamat pool berdasarkan pilihan
if [[ "$POOL_CHOICE" == "1" ]]; then
    POOL="pool-a.yatespool.com:31588"
elif [[ "$POOL_CHOICE" == "2" ]]; then
    POOL="pool-b.yatespool.com:32488"
fi

# Pilihan penggunaan CPU
read -p "Batasi jumlah CPU? (y/n): " LIMIT_CPU

CPU_DEVICES=""
if [[ "$LIMIT_CPU" == "y" || "$LIMIT_CPU" == "Y" ]]; then
    read -p "Masukkan jumlah CPU yang ingin digunakan: " CPU_COUNT
    for ((i=0; i<CPU_COUNT; i++)); do
        CPU_DEVICES+=" --cpu-devices $i"
    done
fi

# Jalankan miner dengan parameter yang telah disusun
./$MINER_FILE --pool stratum+tcp://$WALLET.$WORKER@$POOL $CPU_DEVICES
