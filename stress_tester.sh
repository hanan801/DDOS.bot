#!/bin/bash

# AGGRESSIVE LOAD TESTING TOOL FOR SELF-OWNED WEBSITES
# Author: Security Testing
# Version: 4.0-STRESS

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
echo "    ███████╗████████╗██████╗ ███████╗███████╗███████╗"
echo "    ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝"
echo "    ███████╗   ██║   ██████╔╝█████╗  █████╗  ███████╗"
echo "    ╚════██║   ██║   ██╔══██╗██╔══╝  ██╔══╝  ╚════██║"
echo "    ███████║   ██║   ██║  ██║███████╗██║     ███████║"
echo "    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚══════╝"
echo -e "${NC}"
echo -e "${YELLOW}STRESS TESTING TOOL v4.0${NC}"
echo -e "${RED}WARNING: For YOUR OWN websites only!${NC}"
echo ""

# Configuration
CONFIG_FILE="stress_config.json"
LOG_FILE="stress_results.log"
STATS_FILE="stress_stats.json"

# Aggressive default configuration
DEFAULT_CONFIG='{
    "max_threads": 100,
    "max_requests_per_thread": 1000,
    "max_duration": 1800,
    "timeout": 30,
    "allowed_methods": ["GET", "POST", "HEAD", "PUT", "DELETE"],
    "aggressive_mode": true,
    "max_concurrent": 50
}'

# Initialize configuration
init_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "$DEFAULT_CONFIG" > "$CONFIG_FILE"
        echo -e "${GREEN}[+] Created aggressive config file: $CONFIG_FILE${NC}"
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

# Advanced stress setup
stress_setup() {
    echo -e "${RED}=== STRESS TEST SETUP ===${NC}"
    echo -e "${YELLOW}WARNING: This can make your website unusable!${NC}"
    echo ""
    
    # Get target URL
    TARGET_URL=$(get_user_input "Enter target URL: " "" "url")
    
    # Test type selection
    echo ""
    echo -e "${CYAN}Select Stress Level:${NC}"
    echo "1. Light Load (10 threads, 100 requests)"
    echo "2. Medium Load (25 threads, 500 requests)" 
    echo "3. Heavy Load (50 threads, 1000 requests)"
    echo "4. Extreme Load (100 threads, 2000 requests)"
    echo "5. Custom (Set your own parameters)"
    echo ""
    
    read -p "Select level [1-5]: " level_choice
    
    case $level_choice in
        1)
            THREADS=10
            REQUESTS_PER_THREAD=100
            DELAY=0.5
            ;;
        2)
            THREADS=25
            REQUESTS_PER_THREAD=500
            DELAY=0.2
            ;;
        3)
            THREADS=50
            REQUESTS_PER_THREAD=1000
            DELAY=0.1
            ;;
        4)
            THREADS=100
            REQUESTS_PER_THREAD=2000
            DELAY=0.05
            ;;
        5)
            THREADS=$(get_user_input "Number of threads (1-1000): " "50" "number")
            REQUESTS_PER_THREAD=$(get_user_input "Requests per thread: " "1000" "number")
            DELAY=$(get_user_input "Delay between requests (0 for maximum aggression): " "0" "number")
            ;;
        *)
            echo -e "${RED}Invalid selection, using Heavy Load${NC}"
            THREADS=50
            REQUESTS_PER_THREAD=1000
            DELAY=0.1
            ;;
    esac
    
    # Get HTTP method
    METHOD=$(get_user_input "HTTP method (GET/POST/HEAD/PUT/DELETE): " "GET" "method")
    
    # Get test duration
    DURATION=$(get_user_input "Test duration in seconds (0 for unlimited): " "0" "number")
    
    # Additional aggressive options
    echo ""
    read -p "Enable database-intensive requests? (y/N): " db_intensive
    read -p "Enable large file downloads? (y/N): " large_files
    read -p "Enable concurrent connection storm? (y/N): " connection_storm
    
    # Confirm with strong warning
    echo ""
    echo -e "${RED}=== DANGER: STRESS TEST CONFIRMATION ===${NC}"
    echo -e "Target URL: ${RED}$TARGET_URL${NC}"
    echo -e "Threads: ${RED}$THREADS${NC}"
    echo -e "Requests per thread: ${RED}$REQUESTS_PER_THREAD${NC}"
    echo -e "Total requests: ${RED}$((THREADS * REQUESTS_PER_THREAD))${NC}"
    echo -e "HTTP Method: ${RED}$METHOD${NC}"
    echo -e "Delay: ${RED}$DELAY seconds${NC}"
    if [ "$DURATION" -gt 0 ]; then
        echo -e "Duration: ${RED}$DURATION seconds${NC}"
    else
        echo -e "Duration: ${RED}Unlimited${NC}"
    fi
    echo ""
    echo -e "${RED}THIS CAN CRASH YOUR WEBSITE!${NC}"
    echo ""
    
    read -p "Type 'YES_CRASH' to confirm: " confirm
    if [ "$confirm" != "YES_CRASH" ]; then
        echo -e "${YELLOW}[!] Test cancelled${NC}"
        return 1
    fi
    
    return 0
}

# Enhanced request with more stress options
send_stress_request() {
    local target="$1"
    local thread_id="$2"
    local request_num="$3"
    local method="$4"
    local db_intensive="$5"
    local large_files="$6"
    
    # Multiple cache busting parameters
    local cache_bust="cache_bust=${RANDOM}${request_num}&rnd=${RANDOM}&time=$(date +%s)"
    if [[ "$target" == *"?"* ]]; then
        target="${target}&${cache_bust}"
    else
        target="${target}?${cache_bust}"
    fi
    
    # Database intensive - add parameters that might trigger DB queries
    if [ "$db_intensive" = "y" ] || [ "$db_intensive" = "Y" ]; then
        target="${target}&search=test${RANDOM}&filter=category${RANDOM}&sort=date"
    fi
    
    # Large files - target larger resources
    if [ "$large_files" = "y" ] || [ "$large_files" = "Y" ]; then
        # Alternate between different large resources
        case $((RANDOM % 4)) in
            0) target="${target}/large-image.jpg" ;;
            1) target="${target}/big-file.pdf" ;;
            2) target="${target}/video-preview.mp4" ;;
            3) target="${target}/api/data/export" ;;
        esac
    fi
    
    # Common headers with variations
    local user_agents=(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36"
        "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15"
    )
    local user_agent="${user_agents[$RANDOM % ${#user_agents[@]}]}"
    
    # Build aggressive curl command
    local curl_cmd="curl -s -o /dev/null"
    curl_cmd="$curl_cmd -X $method"
    curl_cmd="$curl_cmd -H 'User-Agent: $user_agent'"
    curl_cmd="$curl_cmd -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'"
    curl_cmd="$curl_cmd -H 'Accept-Language: en-US,en;q=0.9'"
    curl_cmd="$curl_cmd -H 'Cache-Control: no-cache, no-store, must-revalidate'"
    curl_cmd="$curl_cmd -H 'Pragma: no-cache'"
    curl_cmd="$curl_cmd -H 'Connection: keep-alive'"
    curl_cmd="$curl_cmd -m $TIMEOUT"
    
    # For POST requests, add some data
    if [ "$method" = "POST" ]; then
        curl_cmd="$curl_cmd -H 'Content-Type: application/x-www-form-urlencoded'"
        curl_cmd="$curl_cmd -d 'username=testuser${RANDOM}&password=testpass${RANDOM}&action=submit'"
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
        
        echo "$(date '+%Y-%m-%d %H:%M:%S'),$thread_id,$request_num,$target,$http_code,$response_time,$size,$duration,$speed" >> "$LOG_FILE"
        
        update_stress_stats "$http_code" "$duration"
        
        # Show aggressive progress
        if [[ "$http_code" =~ ^[2-3][0-9][0-9]$ ]]; then
            echo -e "${GREEN}[→] T$thread_ID R$request_num: $http_code (${response_time}s)${NC}"
        elif [[ "$http_code" =~ ^[4][0-9][0-9]$ ]]; then
            echo -e "${YELLOW}[⚠] T$thread_ID R$request_num: $http_code (${response_time}s)${NC}"
        elif [[ "$http_code" =~ ^[5][0-9][0-9]$ ]]; then
            echo -e "${RED}[💥] T$thread_ID R$request_num: $http_code (${response_time}s)${NC}"
        else
            echo -e "${PURPLE}[?] T$thread_ID R$request_num: $http_code (${response_time}s)${NC}"
        fi
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S'),$thread_id,$request_num,$target,TIMEOUT,0,0,$duration,0" >> "$LOG_FILE"
        echo -e "${RED}[⏰] T$thread_ID R$request_num: TIMEOUT${NC}"
        update_stress_stats "TIMEOUT" "$duration"
    fi
}

# Stress worker function
stress_worker() {
    local thread_id="$1"
    local target="$2"
    local method="$3"
    local delay="$4"
    local db_intensive="$5"
    local large_files="$6"
    local connection_storm="$7"
    
    local requests=$REQUESTS_PER_THREAD
    if [ "$connection_storm" = "y" ] || [ "$connection_storm" = "Y" ]; then
        # For connection storm, keep opening new connections
        while [ $STOP_TEST -eq 0 ]; do
            send_stress_request "$target" "$thread_id" "$((requests++))" "$method" "$db_intensive" "$large_files"
            if [ "$delay" != "0" ]; then
                sleep "$delay"
            fi
        done
    else
        # Normal operation
        for ((i=1; i<=REQUESTS_PER_THREAD; i++)); do
            if [ $STOP_TEST -eq 1 ]; then
                break
            fi
            
            send_stress_request "$target" "$thread_id" "$i" "$method" "$db_intensive" "$large_files"
            
            if [ "$delay" != "0" ]; then
                sleep "$delay"
            fi
        done
    fi
}

# Update stress statistics
update_stress_stats() {
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
    "estimated_impact": "None"
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
    
    # Estimate impact
    local impact="None"
    local error_rate=$((error_requests * 100 / total_requests))
    if [ $error_rate -gt 50 ]; then
        impact="High (Website likely down)"
    elif [ $error_rate -gt 20 ]; then
        impact="Medium (Website struggling)"
    elif [ $error_rate -gt 5 ]; then
        impact="Low (Minor issues)"
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
    "estimated_impact": "$impact"
}
EOF
}

# Show stress statistics
show_stress_stats() {
    if [ -f "$STATS_FILE" ]; then
        local stats=$(cat "$STATS_FILE")
        local total_requests=$(echo "$stats" | jq '.total_requests')
        local successful_requests=$(echo "$stats" | jq '.successful_requests')
        local failed_requests=$(echo "$stats" | jq '.failed_requests')
        local error_requests=$(echo "$stats" | jq '.error_requests')
        local avg_response_time=$(echo "$stats" | jq '.average_response_time')
        local impact=$(echo "$stats" | jq -r '.estimated_impact')
        
        local success_rate=0
        local error_rate=0
        if [ "$total_requests" -gt 0 ]; then
            success_rate=$((successful_requests * 100 / total_requests))
            error_rate=$((error_requests * 100 / total_requests))
        fi
        
        echo ""
        echo -e "${RED}=== STRESS TEST STATISTICS ===${NC}"
        echo -e "Total Requests: ${CYAN}$total_requests${NC}"
        echo -e "Successful: ${GREEN}$successful_requests${NC}"
        echo -e "Client Errors: ${YELLOW}$failed_requests${NC}"
        echo -e "Server Errors/Timeouts: ${RED}$error_requests${NC}"
        echo -e "Success Rate: ${GREEN}$success_rate%${NC}"
        echo -e "Error Rate: ${RED}$error_rate%${NC}"
        echo -e "Avg Response Time: ${BLUE}$avg_response_time ms${NC}"
        echo -e "Estimated Impact: ${RED}$impact${NC}"
        
        # Show status code distribution
        echo -e "${CYAN}Status Codes:${NC}"
        echo "$stats" | jq -r '.status_codes | to_entries | map("  \(.key): \(.value)") | join("\n")'
    fi
}

# Start stress test
start_stress_test() {
    if ! stress_setup; then
        return 1
    fi
    
    echo -e "${RED}[+] Starting STRESS TEST...${NC}"
    echo -e "${YELLOW}[!] Target: $TARGET_URL${NC}"
    echo -e "${YELLOW}[!] Press Ctrl+C to stop the test${NC}"
    
    # Initialize log file with headers
    echo "timestamp,thread_id,request_num,target,http_code,response_time,size,duration,speed" > "$LOG_FILE"
    
    # Initialize stats
    rm -f "$STATS_FILE"
    
    local start_time=$(date +%s)
    STOP_TEST=0
    
    # Setup signal handler
    trap 'STOP_TEST=1; echo -e "\n${YELLOW}[!] Stopping stress test...${NC}"' SIGINT SIGTERM
    
    # Start monitor
    (
        while [ $STOP_TEST -eq 0 ] && { [ "$DURATION" -eq 0 ] || [ $(($(date +%s) - start_time)) -lt $DURATION ]; }; do
            clear
            show_stress_stats
            local elapsed=$(($(date +%s) - start_time))
            if [ "$DURATION" -gt 0 ]; then
                echo -e "\n${YELLOW}[!] Stress test running... Time: ${elapsed}s/${DURATION}s${NC}"
            else
                echo -e "\n${YELLOW}[!] Stress test running... Time: ${elapsed}s${NC}"
            fi
            echo -e "${RED}[!] Press Ctrl+C to stop${NC}"
            sleep 3
        done
    ) &
    local monitor_pid=$!
    
    # Start stress worker threads
    local pids=()
    for ((i=1; i<=THREADS; i++)); do
        stress_worker "$i" "$TARGET_URL" "$METHOD" "$DELAY" "$db_intensive" "$large_files" "$connection_storm" &
        pids+=($!)
        
        # Stagger thread startup for more realistic load
        sleep 0.01
    done
    
    # Wait for duration or early stop
    if [ "$DURATION" -gt 0 ]; then
        while [ $STOP_TEST -eq 0 ] && [ $(($(date +%s) - start_time)) -lt $DURATION ]; do
            sleep 1
        done
    else
        # Unlimited duration - wait for interrupt
        while [ $STOP_TEST -eq 0 ]; do
            sleep 1
        done
    fi
    
    STOP_TEST=1
    
    # Stop monitor
    kill $monitor_pid 2>/dev/null
    
    # Wait for all workers
    for pid in "${pids[@]}"; do
        wait $pid 2>/dev/null
    done
    
    local end_time=$(date +%s)
    local total_duration=$((end_time - start_time))
    
    echo -e "${GREEN}[+] Stress test completed!${NC}"
    echo -e "Total duration: ${YELLOW}${total_duration}s${NC}"
    
    show_stress_stats
    
    # Final impact assessment
    if [ -f "$STATS_FILE" ]; then
        local stats=$(cat "$STATS_FILE")
        local error_requests=$(echo "$stats" | jq '.error_requests')
        local total_requests=$(echo "$stats" | jq '.total_requests')
        local error_rate=0
        
        if [ "$total_requests" -gt 0 ]; then
            error_rate=$((error_requests * 100 / total_requests))
        fi
        
        echo ""
        echo -e "${RED}=== IMPACT ASSESSMENT ===${NC}"
        if [ $error_rate -gt 60 ]; then
            echo -e "${RED}💥 HIGH IMPACT: Website was likely down or severely impacted${NC}"
        elif [ $error_rate -gt 30 ]; then
            echo -e "${YELLOW}⚠ MEDIUM IMPACT: Website was struggling but partially functional${NC}"
        elif [ $error_rate -gt 10 ]; then
            echo -e "${BLUE}ℹ LOW IMPACT: Minor performance issues detected${NC}"
        else
            echo -e "${GREEN}✓ MINIMAL IMPACT: Website handled the load well${NC}"
        fi
    fi
    
    echo -e "${GREEN}[+] Detailed results saved to: $LOG_FILE${NC}"
}

# Main menu
main_menu() {
    while true; do
        clear
        echo -e "${RED}"
        echo "    ███████╗████████╗██████╗ ███████╗███████╗███████╗"
        echo "    ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝"
        echo "    ███████╗   ██║   ██████╔╝█████╗  █████╗  ███████╗"
        echo "    ╚════██║   ██║   ██╔══██╗██╔══╝  ██╔══╝  ╚════██║"
        echo "    ███████║   ██║   ██║  ██║███████╗██║     ███████║"
        echo "    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚══════╝"
        echo -e "${NC}"
        echo -e "${YELLOW}STRESS TESTING TOOL v4.0${NC}"
        echo -e "${RED}FOR YOUR OWN WEBSITES ONLY!${NC}"
        echo ""
        echo -e "${CYAN}=== MAIN MENU ===${NC}"
        echo "1. Start Stress Test"
        echo "2. View Last Results"
        echo "3. Configuration"
        echo "4. Exit"
        echo ""
        
        read -p "Select option [1-4]: " choice
        
        case $choice in
            1)
                start_stress_test
                read -p "Press Enter to continue..."
                ;;
            2)
                if [ -f "$LOG_FILE" ]; then
                    echo -e "${CYAN}=== LAST STRESS TEST RESULTS ===${NC}"
                    tail -30 "$LOG_FILE" | column -t -s','
                    echo ""
                    if [ -f "$STATS_FILE" ]; then
                        show_stress_stats
                    fi
                else
                    echo -e "${RED}No stress test results found${NC}"
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
                echo -e "${GREEN}[+] Stress testing tool closed${NC}"
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
        echo -e "${YELLOW}[!] Install with: sudo apt install jq${NC}"
        return 1
    fi
    
    if ! command -v curl >/dev/null; then
        echo -e "${RED}[-] curl is required but not installed${NC}"
        echo -e "${YELLOW}[!] Install with: sudo apt install curl${NC}"
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
