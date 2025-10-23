#!/bin/bash

# Skrip Uji Beban Agresif untuk Termux (HANYA untuk situs web milik Anda)
# Skrip ini dirancang untuk menguji kapasitas server Anda dengan performa maksimum,
# namun dengan cara yang aman dan legal. Gunakan dengan tanggung jawab dan hanya di lingkungan yang diizinkan.

# Definisi
TARGET_URL=""       # Masukkan URL situs web Anda (contoh: https://situsanda.com)
NUM_THREADS=50      # Jumlah thread/proses bersamaan
REQUEST_TIMEOUT=10  # Timeout dalam detik untuk setiap permintaan
DURATION=60         # Durasi pengujian dalam detik
RATE_LIMIT=0        # Batas permintaan per detik (0 untuk menonaktifkan)
LOG_FILE="uji_beban.log" # File log untuk hasil
ALLOWED_DOMAINS=""  # Domain yang diizinkan (dipisahkan dengan koma, contoh: situsanda.com,domainlain.com)
                       # Jika kosong, diasumsikan domain dari TARGET_URL

# Variabel Global
TOTAL_REQUESTS=0
SUCCESSFUL_REQUESTS=0
FAILED_REQUESTS=0
START_TIME=$(date +%s)

# Fungsi Utiliti

# Validasi target
validasi_target() {
  if [ -z "$TARGET_URL" ]; then
    echo "ERROR: URL target tidak ditentukan. Tetapkan TARGET_URL."
    exit 1
  fi

  if [ -z "$ALLOWED_DOMAINS" ]; then
    ALLOWED_DOMAINS=$(echo "$TARGET_URL" | awk -F'//' '{print $2}' | awk -F'/' '{print $1}')
    echo "PERINGATAN: ALLOWED_DOMAINS tidak ditentukan. Mengasumsikan domain dari TARGET_URL: $ALLOWED_DOMAINS"
  fi

  target_domain=$(echo "$TARGET_URL" | awk -F'//' '{print $2}' | awk -F'/' '{print $1}')

  diizinkan=false
  for domain in $(echo "$ALLOWED_DOMAINS" | tr "," "\n"); do
    if [ "$target_domain" == "$domain" ]; then
      diizinkan=true
      break
    fi
  done

  if ! $diizinkan; then
    echo "ERROR: Target ($TARGET_URL) tidak ada dalam daftar domain yang diizinkan ($ALLOWED_DOMAINS). Pengujian dibatalkan."
    exit 1
  fi
}

# Hasilkan User-Agent acak
acak_user_agent() {
  local agents=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:89.0) Gecko/20100101 Firefox/89.0"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/91.0.864.59"
  )
  echo "${agents[$((RANDOM % ${#agents[@]}))]}"
}

# Cache busting (menambahkan parameter acak ke URL)
cache_busting_url() {
  echo "$TARGET_URL?cachebuster=$(date +%s%N)"
}

# Fungsi utama untuk melakukan permintaan
lakukan_permintaan() {
  local url=$(cache_busting_url)
  local user_agent=$(acak_user_agent)
  local start=$(date +%s%N)

  # Pilih metode HTTP acak
  local methods=("GET" "POST" "HEAD" "PUT")
  local method="${methods[$((RANDOM % ${#methods[@]}))]}"

  curl -s -w "%{http_code} %{time_total}" \
       -H "User-Agent: $user_agent" \
       -H "Connection: keep-alive" \
       -X "$method" \
       --max-time $REQUEST_TIMEOUT \
       "$url" 2>&1 | while read -r line; do
    local status_code=$(echo "$line" | awk '{print $1}')
    local response_time=$(echo "$line" | awk '{print $2}')

    ((TOTAL_REQUESTS++))

    if [[ "$status_code" =~ ^[23] ]]; then  # Anggap 2xx dan 3xx sebagai sukses
      ((SUCCESSFUL_REQUESTS++))
    else
      ((FAILED_REQUESTS++))
    fi

    local end=$(date +%s%N)
    local duration=$((end - start))

    echo "$(date +%Y-%m-%d\ %H:%M:%S) - URL: $url, Metode: $method, Status: $status_code, Waktu: $response_time detik" >> "$LOG_FILE"
  done
}

# Fungsi untuk pemantauan waktu nyata dan statistik
pantau_statistik() {
  while true; do
    sleep 1
    local now=$(date +%s)
    local elapsed=$((now - START_TIME))

    if [ "$elapsed" -ge "$DURATION" ]; then
      echo "Waktu habis. Mengakhiri pengujian."
      break
    fi

    local req_per_sec=$((TOTAL_REQUESTS / elapsed))
    local success_rate=$((SUCCESSFUL_REQUESTS * 100 / TOTAL_REQUESTS))
    local fail_rate=$((FAILED_REQUESTS * 100 / TOTAL_REQUESTS))

    echo "--------------------------------------------------"
    echo "Waktu yang berlalu: $elapsed / $DURATION detik"
    echo "Total permintaan: $TOTAL_REQUESTS"
    echo "Permintaan per detik: $req_per_sec"
    echo "Sukses: $SUCCESSFUL_REQUESTS ($success_rate%)"
    echo "Gagal: $FAILED_REQUESTS ($fail_rate%)"
    echo "--------------------------------------------------"

  done
  killall -q -w uji_beban_worker.sh  # Hentikan worker
  exit 0
}

# Penafian Hukum
penafian() {
  echo "--------------------------------------------------"
  echo "PENOLAKAN HUKUM:"
  echo "Skrip ini HANYA boleh digunakan untuk menguji situs web milik Anda"
  echo "dengan izin eksplisit. Penyalahgunaan adalah ilegal dan tidak etis."
  echo "Penulis tidak bertanggung jawab atas kerusakan apa pun yang disebabkan oleh penggunaan skrip ini."
  echo "--------------------------------------------------"
}

# Konfirmasi Pengguna
konfirmasi_eksekusi() {
  read -r -p "Anda mengonfirmasi bahwa Anda memiliki izin untuk menguji situs web $TARGET_URL? (y/n) " response
  case "$response" in
    [Yy]* )
      echo "Memulai pengujian beban..."
      ;;
    [Nn]* )
      echo "Pengujian dibatalkan."
      exit 1
      ;;
    * )
      echo "Respons tidak valid. Pengujian dibatalkan."
      exit 1
      ;;
  esac
}

# Skrip worker untuk setiap thread
cat > uji_beban_worker.sh <<EOF
#!/bin/bash

while true; do
  lakukan_permintaan
  if [ "$RATE_LIMIT" -gt 0 ]; then
    sleep 1/$RATE_LIMIT  # Batasi laju permintaan
  fi
done
EOF
chmod +x uji_beban_worker.sh

# Fungsi utama untuk memulai pengujian
utama() {
  penafian
  validasi_target
  konfirmasi_eksekusi

  echo "Memulai pengujian beban pada $TARGET_URL dengan $NUM_THREADS thread selama $DURATION detik..."
  echo "Hasil akan dicatat di $LOG_FILE"

  # Mulai pemantauan di latar belakang
  pantau_statistik &

  # Mulai thread/proses di latar belakang
  for ((i=1; i<=$NUM_THREADS; i++)); do
    ./uji_beban_worker.sh &
  done

  wait  # Tunggu hingga semua proses anak selesai (pantau_statistik dan worker)

  echo "Pengujian beban selesai."
  echo "Hasil terperinci ada di $LOG_FILE"
}

# Mulai skrip
utama
