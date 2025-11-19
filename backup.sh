#!/bin/bash

#############################################################
# BACKUP.SH - Segurtasun Kopia Automatikoa
#############################################################
# Script honek aplikazioaren webgunearen segurtasun kopia bat
# sortzen du .tar.gz formatuan, egungo data izena erabiliz
#############################################################

# Konfigurazioa
ITURRIA="/var/www/html/app"
HELMUGA="/backup"
DATA=$(date +%Y%m%d_%H%M%S)
FITXATEGI_IZENA="backup_${DATA}.tar.gz"
LOG_FITXATEGIA="/var/log/backup.log"

# Koloreak outputerako
BERDEA='\033[0;32m'
GORRIA='\033[0;31m'
HORIA='\033[1;33m'
KOLORIK_EZ='\033[0m'

# FUNTZIOAK

# Log mezuak idazteko funtzioa
log_mezua() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FITXATEGIA"
}

# Errorea kudeatzeko funtzioa
errorea_kudeatu() {
    echo -e "${GORRIA}[ERROREA]${KOLORIK_EZ} $1" | tee -a "$LOG_FITXATEGIA"
    exit 1
}

# BACKUP PROZESUA
echo -e "${HORIA}======================================${KOLORIK_EZ}"
echo -e "${HORIA}  SEGURTASUN KOPIA SCRIPT-A HASI${KOLORIK_EZ}"
echo -e "${HORIA}======================================${KOLORIK_EZ}"
log_mezua "Backup prozesua hasi da"

# Egiaztatu iturria existitzen dela
if [ ! -d "$ITURRIA" ]; then
    errorea_kudeatu "Iturri direktoriorik ez da aurkitu: $ITURRIA"
fi

# Sortu helmuga direktoriorik ez badago
if [ ! -d "$HELMUGA" ]; then
    log_mezua "Helmuga direktorioa sortzen: $HELMUGA"
    mkdir -p "$HELMUGA" || errorea_kudeatu "Ezin izan da helmuga direktorioa sortu"
fi

# Egin segurtasun kopia
log_mezua "Segurtasun kopia sortzen: $FITXATEGI_IZENA"
echo -e "${HORIA}Konprimitzen...${KOLORIK_EZ}"

tar -czf "$HELMUGA/$FITXATEGI_IZENA" -C "$(dirname $ITURRIA)" "$(basename $ITURRIA)" 2>> "$LOG_FITXATEGIA"

if [ $? -eq 0 ]; then
    TAMAINA=$(du -h "$HELMUGA/$FITXATEGI_IZENA" | cut -f1)
    echo -e "${BERDEA}[ARRAKASTA]${KOLORIK_EZ} Backup-a ondo sortu da!"
    log_mezua "Backup-a arrakastaz sortu da: $FITXATEGI_IZENA (Tamaina: $TAMAINA)"
    echo -e "Fitxategia: ${BERDEA}$HELMUGA/$FITXATEGI_IZENA${KOLORIK_EZ}"
    echo -e "Tamaina: ${BERDEA}$TAMAINA${KOLORIK_EZ}"
else
    errorea_kudeatu "Backup-a sortzean errorea gertatu da"
fi

# Zaharrak ezabatu (30 egun baino zaharragoak)
log_mezua "30 egun baino zaharragoak diren backup-ak ezabatzen..."
find "$HELMUGA" -name "backup_*.tar.gz" -type f -mtime +30 -delete 2>> "$LOG_FITXATEGIA"

echo -e "${BERDEA}======================================${KOLORIK_EZ}"
echo -e "${BERDEA}  PROZESUA OSATUTA${KOLORIK_EZ}"
echo -e "${BERDEA}======================================${KOLORIK_EZ}"
log_mezua "Backup prozesua amaitu da"

exit 0