#!/bin/bash

# Script de Teste de Carga Agressivo para Termux (APENAS para sites de sua propriedade)
# Este script foi projetado para testar a capacidade de seus servidores com máximo desempenho,
# mas de forma segura e legal.  Use com responsabilidade e apenas em ambientes autorizados.

# Definições
TARGET_URL=""       # Insira o URL do seu site (ex: https://seusite.com)
NUM_THREADS=50      # Número de threads/processos simultâneos
REQUEST_TIMEOUT=10  # Timeout em segundos para cada requisição
DURATION=60         # Duração do teste em segundos
RATE_LIMIT=0        # Limite de requisições por segundo (0 para desativar)
LOG_FILE="load_test.log" # Arquivo de log para os resultados
ALLOWED_DOMAINS=""  # Domínios autorizados (separados por vírgula, ex: seusite.com,outrodominio.com)
                       # Se vazio, assume o domínio do TARGET_URL

# Variáveis Globais
TOTAL_REQUESTS=0
SUCCESSFUL_REQUESTS=0
FAILED_REQUESTS=0
START_TIME=$(date +%s)

# Funções Utilitárias

# Validação do alvo
validate_target() {
  if [ -z "$TARGET_URL" ]; then
    echo "ERRO: URL do alvo não especificado.  Defina TARGET_URL."
    exit 1
  fi

  if [ -z "$ALLOWED_DOMAINS" ]; then
    ALLOWED_DOMAINS=$(echo "$TARGET_URL" | awk -F'//' '{print $2}' | awk -F'/' '{print $1}')
    echo "AVISO: ALLOWED_DOMAINS não especificado. Assumindo domínio de TARGET_URL: $ALLOWED_DOMAINS"
  fi

  target_domain=$(echo "$TARGET_URL" | awk -F'//' '{print $2}' | awk -F'/' '{print $1}')

  allowed=false
  for domain in $(echo "$ALLOWED_DOMAINS" | tr "," "\n"); do
    if [ "$target_domain" == "$domain" ]; then
      allowed=true
      break
    fi
  done

  if ! $allowed; then
    echo "ERRO: Alvo ($TARGET_URL) não está na lista de domínios autorizados ($ALLOWED_DOMAINS).  Teste abortado."
    exit 1
  fi
}

# Geração de User-Agent aleatório
random_user_agent() {
  local agents=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:89.0) Gecko/20100101 Firefox/89.0"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/91.0.864.59"
  )
  echo "${agents[$((RANDOM % ${#agents[@]}))]}"
}

# Cache busting (adiciona um parâmetro aleatório à URL)
cache_busting_url() {
  echo "$TARGET_URL?cachebuster=$(date +%s%N)"
}

# Função principal para realizar as requisições
perform_request() {
  local url=$(cache_busting_url)
  local user_agent=$(random_user_agent)
  local start=$(date +%s%N)

  # Seleciona um método HTTP aleatório
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

    if [[ "$status_code" =~ ^[23] ]]; then  # Considera 2xx e 3xx como sucesso
      ((SUCCESSFUL_REQUESTS++))
    else
      ((FAILED_REQUESTS++))
    fi

    local end=$(date +%s%N)
    local duration=$((end - start))

    echo "$(date +%Y-%m-%d\ %H:%M:%S) - URL: $url, Method: $method, Status: $status_code, Time: $response_time seconds" >> "$LOG_FILE"
  done
}

# Função para monitoramento em tempo real e estatísticas
monitor_stats() {
  while true; do
    sleep 1
    local now=$(date +%s)
    local elapsed=$((now - START_TIME))

    if [ "$elapsed" -ge "$DURATION" ]; then
      echo "Tempo limite atingido.  Finalizando teste."
      break
    fi

    local req_per_sec=$((TOTAL_REQUESTS / elapsed))
    local success_rate=$((SUCCESSFUL_REQUESTS * 100 / TOTAL_REQUESTS))
    local fail_rate=$((FAILED_REQUESTS * 100 / TOTAL_REQUESTS))

    echo "--------------------------------------------------"
    echo "Tempo decorrido: $elapsed / $DURATION segundos"
    echo "Requisições totais: $TOTAL_REQUESTS"
    echo "Requisições por segundo: $req_per_sec"
    echo "Sucesso: $SUCCESSFUL_REQUESTS ($success_rate%)"
    echo "Falha: $FAILED_REQUESTS ($fail_rate%)"
    echo "--------------------------------------------------"

  done
  killall -q -w bash_load_worker.sh  # Encerra os workers
  exit 0
}

# Disclaimer Legal
disclaimer() {
  echo "--------------------------------------------------"
  echo "AVISO LEGAL:"
  echo "Este script deve ser usado APENAS para testar sites de sua propriedade"
  echo "com permissão explícita.  O uso indevido é ilegal e antiético."
  echo "O autor não se responsabiliza por quaisquer danos causados pelo uso deste script."
  echo "--------------------------------------------------"
}

# Confirmação do Usuário
confirm_execution() {
  read -r -p "Você confirma que possui permissão para testar o site $TARGET_URL? (s/n) " response
  case "$response" in
    [Ss]* )
      echo "Iniciando teste de carga..."
      ;;
    [Nn]* )
      echo "Teste abortado."
      exit 1
      ;;
    * )
      echo "Resposta inválida. Teste abortado."
      exit 1
      ;;
  esac
}

# Script worker para cada thread
cat > bash_load_worker.sh <<EOF
#!/bin/bash

while true; do
  perform_request
  if [ "$RATE_LIMIT" -gt 0 ]; then
    sleep 1/$RATE_LIMIT  # Limita a taxa de requisições
  fi
done
EOF
chmod +x bash_load_worker.sh

# Função principal para iniciar o teste
main() {
  disclaimer
  validate_target
  confirm_execution

  echo "Iniciando teste de carga em $TARGET_URL com $NUM_THREADS threads durante $DURATION segundos..."
  echo "Resultados serão registrados em $LOG_FILE"

  # Inicia o monitoramento em background
  monitor_stats &

  # Inicia os threads/processos em background
  for ((i=1; i<=$NUM_THREADS; i++)); do
    ./bash_load_worker.sh &
  done

  wait  # Aguarda a finalização de todos os processos filhos (monitor_stats e workers)

  echo "Teste de carga finalizado."
  echo "Resultados detalhados em $LOG_FILE"
}

# Inicia o script
main
