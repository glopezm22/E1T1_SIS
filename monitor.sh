#!/bin/bash

#############################################################
# MONITOR.SH - Sistema Baliabideen Monitorizazio Script-a
#############################################################
# Script honek sistemaren baliabideen informazioa
# batzen du eta fitxategi batean gordetzen du
#############################################################

# Konfigurazioa
LOG_DIR="/var/log/monitor"
DATA=$(date +%Y%m%d_%H%M%S)
LOG_FITXATEGIA="${LOG_DIR}/monitor-${DATA}.log"

# Koloreak
URDIN='\033[0;34m'
BERDEA='\033[0;32m'
KOLORIK_EZ='\033[0m'

# HASIERAKO KONFIGURAZIOA

# Sortu log direktorioa ez badago
if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
fi

# INFORMAZIOA BILTZEKO FUNTZIOAK
print_header() {
    echo "========================================" | tee -a "$LOG_FITXATEGIA"
    echo "$1" | tee -a "$LOG_FITXATEGIA"
    echo "========================================" | tee -a "$LOG_FITXATEGIA"
    echo "" | tee -a "$LOG_FITXATEGIA"
}

# MONITORIZAZIO PROZESUA
echo -e "${URDIN}Sistema baliabideen monitorizazioa hasten...${KOLORIK_EZ}"
echo ""

# Hasierako informazioa
{
    echo "SISTEMA MONITORIZAZIO TXOSTENA"
    echo "Data eta Ordua: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Hostname: $(hostname)"
    echo "Kernel: $(uname -r)"
    echo ""
} | tee "$LOG_FITXATEGIA"

# 1. SISTEMA INFORMAZIOA ETA UPTIME
print_header "1. SISTEMA INFORMAZIOA ETA UPTIME"
{
    echo "Uptime informazioa:"
    uptime
    echo ""
    echo "Sistema karga (1, 5, 15 minutu):"
    cat /proc/loadavg
    echo ""
} | tee -a "$LOG_FITXATEGIA"

# 2. CPU ETA PROZESUEN INFORMAZIOA
print_header "2. CPU ETA PROZESUEN INFORMAZIOA"
{
    echo "CPU informazioa:"
    lscpu | grep -E "Model name|CPU\(s\)|Thread|Core"
    echo ""
    echo "Top 10 prozesu CPU arabera:"
    ps aux --sort=-%cpu | head -11
    echo ""
} | tee -a "$LOG_FITXATEGIA"

# 3. MEMORIA ERABILERA
print_header "3. MEMORIA ERABILERA"
{
    echo "Memoria erabilera:"
    free -h
    echo ""
    echo "Top 10 prozesu memoria arabera:"
    ps aux --sort=-%mem | head -11
    echo ""
} | tee -a "$LOG_FITXATEGIA"

# 4. DISKOKO ERABILERA
print_header "4. DISKOKO PARTIZIOEN ERABILERA"
{
    echo "Partizioen erabilera:"
    df -h
    echo ""
    echo "Inodo erabilera:"
    df -i
    echo ""
} | tee -a "$LOG_FITXATEGIA"

# 5. SARE INFORMAZIOA
print_header "5. SARE KONFIGURAZIOA ETA KONEXIOAK"
{
    echo "Sare interfazeak:"
    ip -br addr
    echo ""
    echo "Konexio aktiboak:"
    ss -tuln | head -20
    echo ""
    echo "Konexio kopurua egoeraren arabera:"
    ss -tan | awk '{print $1}' | sort | uniq -c | sort -rn
    echo ""
} | tee -a "$LOG_FITXATEGIA"

# 6. I/O ESTATISTIKAK
if command -v iostat &> /dev/null; then
    print_header "6. DISKOKO I/O ESTATISTIKAK"
    {
        echo "Diskoko I/O estatistikak:"
        iostat -x 1 2
        echo ""
    } | tee -a "$LOG_FITXATEGIA"
fi

# 7. ZERBITZUEN EGOERA
print_header "7. ZERBITZUEN EGOERA"
{
    echo "SSH zerbitzua:"
    systemctl status ssh --no-pager -l | head -10
    echo ""
    
    echo "Apache2 zerbitzua:"
    systemctl status apache2 --no-pager -l 2>/dev/null | head -10 || echo "Ez dago instalatuta"
    echo ""
    
    echo "VSFTPD zerbitzua:"
    systemctl status vsftpd --no-pager -l 2>/dev/null | head -10 || echo "Ez dago instalatuta"
    echo ""
} | tee -a "$LOG_FITXATEGIA"

# AMAIERA
{
    echo ""
    echo "========================================"
    echo "MONITORIZAZIOA OSATUTA"
    echo "========================================"
    echo "Log fitxategia: $LOG_FITXATEGIA"
} | tee -a "$LOG_FITXATEGIA"

echo ""
echo -e "${BERDEA}Monitorizazioa ondo osatu da!${KOLORIK_EZ}"
echo -e "Emaitzak hemen: ${BERDEA}$LOG_FITXATEGIA${KOLORIK_EZ}"

# Zaharrak garbitu (7 egun baino zaharragoak)
find "$LOG_DIR" -name "monitor-*.log" -type f -mtime +7 -delete

exit 0