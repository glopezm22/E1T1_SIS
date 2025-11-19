# Zerbitzuen Monitorizazio Taula

**Data:** _______________
**Ordua:** _______________
**Zerbitzaria:** _______________

---

## 1. Zerbitzu Nagusien Egoera

### 1.1 Egoera Taula

| Zerbitzua | Komandoa | Egoera | Portua | Enabled | Azken Egiaztapena |
|-----------|----------|--------|--------|---------|-------------------|
| **SSH** | `systemctl status ssh` | ⬜ Active ⬜ Inactive ⬜ Failed | 22 | ⬜ Bai ⬜ Ez | _____ |
| **VSFTPD** | `systemctl status vsftpd` | ⬜ Active ⬜ Inactive ⬜ Failed | 21 | ⬜ Bai ⬜ Ez | _____ |
| **Apache2** | `systemctl status apache2` | ⬜ Active ⬜ Inactive ⬜ Failed | 80, 443 | ⬜ Bai ⬜ Ez | _____ |
| **Nginx** | `systemctl status nginx` | ⬜ Active ⬜ Inactive ⬜ Failed | 80, 443 | ⬜ Bai ⬜ Ez | _____ |
| **MySQL/MariaDB** | `systemctl status mysql` | ⬜ Active ⬜ Inactive ⬜ Failed | 3306 | ⬜ Bai ⬜ Ez | _____ |
| **Backend App** | `systemctl status backend-app` | ⬜ Active ⬜ Inactive ⬜ Failed | 3000 | ⬜ Bai ⬜ Ez | _____ |

### Lehendia:
- 🟢 **Active (running)**: Zerbitzua ondo funtzionatzen ari da
- 🟡 **Inactive (dead)**: Zerbitzua geldirik dago
- 🔴 **Failed**: Zerbitzuak errorea du eta ez dabil

---

## 2. SSH Zerbitzua

### 2.1 Egoera Egiaztapena

**Komandoa:**
```bash
sudo systemctl status ssh
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

### 2.2 Informazio Xehatua

| Parametroa | Balioa |
|------------|--------|
| **Loaded** | ⬜ loaded ⬜ not-found |
| **Active** | ⬜ active (running) ⬜ inactive ⬜ failed |
| **PID** | _____ |
| **Memory** | _____ MB |
| **CPU** | _____ % |
| **Uptime** | _____ |

### 2.3 Konexio Aktiboak

**Komandoa:**
```bash
sudo ss -tan | grep :22
```

**Konexio kopurua:** _____

### 2.4 Azken Log Lerroak

```
[Kopiatu azken 5 log lerroak hemen]
```

### 2.5 Ondorioak

- ⬜ Zerbitzua ondo funtzionatzen ari da
- ⬜ Konfigurazio arazoak detektatu dira
- ⬜ Konexio arazoak daude
- **Oharrak:** _________________

---

## 3. VSFTPD Zerbitzua (FTP)

### 3.1 Egoera Egiaztapena

**Komandoa:**
```bash
sudo systemctl status vsftpd
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

### 3.2 Informazio Xehatua

| Parametroa | Balioa |
|------------|--------|
| **Loaded** | ⬜ loaded ⬜ not-found |
| **Active** | ⬜ active (running) ⬜ inactive ⬜ failed |
| **PID** | _____ |
| **Memory** | _____ MB |
| **CPU** | _____ % |
| **Uptime** | _____ |

### 3.3 Erabiltzaile Onartuen Zerrenda

**Komandoa:**
```bash
cat /etc/vsftpd.userlist
```

**Emaitza:**
```
[Kopiatu zerrenda hemen]
```

### 3.4 Konexio Proba

**Komandoa:**
```bash
ftp localhost
```

**Emaitza:**
- ⬜ Konexioa arrakastatsua
- ⬜ Konexio errorea
- **Errorea (badago):** _________________

### 3.5 Azken Log Lerroak

```
[Kopiatu /var/log/vsftpd.log-ko azken 5 lerroak]
```

### 3.6 Ondorioak

- ⬜ Zerbitzua ondo funtzionatzen ari da
- ⬜ Erabiltzaile arazoak
- ⬜ Konexio arazoak
- **Oharrak:** _________________

---

## 4. Apache2 / Nginx Zerbitzua

### 4.1 Egoera Egiaztapena

**Komandoa:**
```bash
sudo systemctl status apache2
# EDO
sudo systemctl status nginx
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

### 4.2 Informazio Xehatua

| Parametroa | Balioa |
|------------|--------|
| **Zerbitzaria** | ⬜ Apache2 ⬜ Nginx |
| **Loaded** | ⬜ loaded ⬜ not-found |
| **Active** | ⬜ active (running) ⬜ inactive ⬜ failed |
| **PID** | _____ |
| **Memory** | _____ MB |
| **CPU** | _____ % |
| **Uptime** | _____ |

### 4.3 Portuen Egiaztapena

**Komandoa:**
```bash
sudo ss -tuln | grep -E ':80|:443'
```

**Emaitza:**

| Portua | Egoera | Protokoloa |
|--------|--------|------------|
| 80 | ⬜ LISTEN ⬜ Ez dago | TCP |
| 443 | ⬜ LISTEN ⬜ Ez dago | TCP |

### 4.4 Konfigurazio Egiaztapena

**Apache2:**
```bash
sudo apache2ctl configtest
```

**Nginx:**
```bash
sudo nginx -t
```

**Emaitza:**
- ⬜ Syntax OK
- ⬜ Syntax error
- **Errorea (badago):** _________________

### 4.5 Virtual Hosts / Server Blocks

**Apache2:**
```bash
sudo apache2ctl -S
```

**Nginx:**
```bash
sudo nginx -T | grep server_name
```

**Emaitza:**
```
[Kopiatu konfiguratuak dauden domeinuak]
```

### 4.6 Konexio Proba

**Komandoa:**
```bash
curl -I http://localhost
curl -I https://localhost
```

**Emaitza:**
- ⬜ HTTP 200 OK
- ⬜ Errorea
- **HTTP kodea:** _____

### 4.7 Azken Log Lerroak

**Apache2:**
```bash
sudo tail -5 /var/log/apache2/error.log
```

**Nginx:**
```bash
sudo tail -5 /var/log/nginx/error.log
```

**Emaitza:**
```
[Kopiatu log lerroak hemen]
```

### 4.8 Ondorioak

- ⬜ Zerbitzua ondo funtzionatzen ari da
- ⬜ Konfigurazio arazoak
- ⬜ SSL/TLS arazoak
- **Oharrak:** _________________

---

## 5. Sistema Baliabideen Laburpena

### 5.1 CPU Erabileraren Laburpena

**Komandoa:**
```bash
top -bn1 | head -3
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

| Metrika | Balioa | Egoera |
|---------|--------|--------|
| **CPU user** | _____% | ⬜ Ondo (< 70%) ⬜ Kargatuta (70-90%) ⬜ Gainkargatuta (> 90%) |
| **CPU system** | _____% | ⬜ Ondo (< 30%) ⬜ Kargatuta (30-50%) ⬜ Gainkargatuta (> 50%) |
| **Load Average 1m** | _____ | ⬜ Ondo ⬜ Kargatuta ⬜ Gainkargatuta |

### 5.2 Memoria Erabileraren Laburpena

**Komandoa:**
```bash
free -h
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

| Metrika | Tamaina | Erabilitako | Libre | % Erabilera | Egoera |
|---------|---------|-------------|-------|-------------|--------|
| **RAM** | _____ GB | _____ GB | _____ GB | _____% | ⬜ Ondo (< 80%) ⬜ Presioa (80-95%) ⬜ Kritikoa (> 95%) |
| **Swap** | _____ GB | _____ GB | _____ GB | _____% | ⬜ Ondo (< 50%) ⬜ Gehiegi (> 50%) |

### 5.3 Diskoko Espazioa

**Komandoa:**
```bash
df -h
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

| Partizioa | Tamaina | Erabilitako | Libre | % Erabilera | Egoera |
|-----------|---------|-------------|-------|-------------|--------|
| **/** | _____ GB | _____ GB | _____ GB | _____% | ⬜ Ondo (< 70%) ⬜ Beteta (70-85%) ⬜ Kritikoa (> 85%) |
| **/home** | _____ GB | _____ GB | _____ GB | _____% | ⬜ Ondo ⬜ Beteta ⬜ Kritikoa |
| **/backup** | _____ GB | _____ GB | _____ GB | _____% | ⬜ Ondo ⬜ Beteta ⬜ Kritikoa |

### 5.4 Uptime eta Sistema Karga

**Komandoa:**
```bash
uptime
```

**Emaitza:**
```
[Kopiatu uptime emaitza]
```

| Metrika | Balioa |
|---------|--------|
| **Uptime** | _____ egun, _____ ordu |
| **Erabiltzaileak** | _____ |
| **Load average (1m)** | _____ |
| **Load average (5m)** | _____ |
| **Load average (15m)** | _____ |

---

## 6. Prozesu Nagusiak

### 6.1 CPU Arabera Top 10

**Komandoa:**
```bash
ps aux --sort=-%cpu | head -11
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

| PID | Erabiltzailea | CPU % | Komandoa | Oharrak |
|-----|---------------|-------|----------|---------|
| _____ | _____ | _____% | _____ | _____ |
| _____ | _____ | _____% | _____ | _____ |
| _____ | _____ | _____% | _____ | _____ |

### 6.2 Memoria Arabera Top 10

**Komandoa:**
```bash
ps aux --sort=-%mem | head -11
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

| PID | Erabiltzailea | MEM % | Komandoa | Oharrak |
|-----|---------------|-------|----------|---------|
| _____ | _____ | _____% | _____ | _____ |
| _____ | _____ | _____% | _____ | _____ |
| _____ | _____ | _____% | _____ | _____ |

---

## 7. Sare Trafikoa

### 7.1 Konexio Kopurua

**Komandoa:**
```bash
ss -tan | awk '{print $1}' | sort | uniq -c | sort -rn
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

| Egoera | Konexio Kopurua | Oharrak |
|--------|-----------------|---------|
| ESTAB | _____ | _____ |
| TIME-WAIT | _____ | _____ |
| LISTEN | _____ | _____ |
| SYN-SENT | _____ | _____ |

### 7.2 Portuka Konexioak

**Komandoa:**
```bash
ss -tuln | grep LISTEN
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

| Portua | Protokoloa | Zerbitzua | Egoera |
|--------|------------|-----------|--------|
| 22 | TCP | SSH | ⬜ LISTEN ⬜ Ez |
| 21 | TCP | FTP | ⬜ LISTEN ⬜ Ez |
| 80 | TCP | HTTP | ⬜ LISTEN ⬜ Ez |
| 443 | TCP | HTTPS | ⬜ LISTEN ⬜ Ez |

---

## 8. Log Laburpena

### 8.1 Sistema Log-ak (azken erroreak)

**Komandoa:**
```bash
sudo journalctl -p err -n 20 --no-pager
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Errore kopurua:** _____

**Errore kritikoak (badaude):**
```
[Kopiatu errore kritikoak hemen]
```

### 8.2 Auth Log-ak (azken saio hasiera saiakerak)

**Komandoa:**
```bash
sudo tail -20 /var/log/auth.log
```

**Emaitza:**
- ⬜ Saio hasiera normalak soilik
- ⬜ Saio hasiera huts saiakerak detektatu dira
- **Kopurua:** _____

---

## 9. Backup eta Script Egoera

### 9.1 Azken Backup-a

**Komandoa:**
```bash
ls -lh /backup/ | tail -5
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

| Fitxategia | Tamaina | Data | Egoera |
|------------|---------|------|--------|
| backup_*.tar.gz | _____ | _____ | ⬜ Ondo ⬜ Ez dago |

### 9.2 Backup Log-a

**Komandoa:**
```bash
tail -10 /var/log/backup.log
```

**Emaitza:**
- ⬜ Azken backup-a arrakastatsua
- ⬜ Erroreak detektatu dira
- **Azken exekuzioa:** _____

### 9.3 Monitorizazio Log-a

**Komandoa:**
```bash
ls -lh /var/log/monitor/ | tail -5
```

**Emaitza:**
- ⬜ Log-ak ondo sortzen dira
- ⬜ Ez dago log berririk
- **Azken log-a:** _____

### 9.4 Cron Zereginak

**Komandoa:**
```bash
sudo crontab -l
```

**Emaitza:**
```
[Kopiatu crontab edukia]
```

---

## 10. Alertak eta Ekintzak

### 10.1 Alertak Detektatuak

⬜ **KRITIKOA**: Zerbitzua failed egoeran
- Zerbitzua: _____
- Ekintza: _____

⬜ **ALTUA**: Diskoa % 85etik gora
- Partizioa: _____
- Ehunekoa: _____
- Ekintza: _____

⬜ **ERTAINA**: Memoria presioa handia (> 90%)
- Ehunekoa: _____
- Ekintza: _____

⬜ **BAXUA**: Log errore normalak
- Kopurua: _____

### 10.2 Hartu Beharreko Ekintzak

1. **Lehentasun altua:**
   - [ ] _____
   - [ ] _____

2. **Lehentasun ertaina:**
   - [ ] _____
   - [ ] _____

3. **Lehentasun baxua:**
   - [ ] _____

---

## 11. Ondorio Orokorrak

### 11.1 Egoera Orokorra

| Arloa | Egoera | Komentarioak |
|-------|--------|--------------|
| Zerbitzuak | ⬜ Ondo ⬜ Arazoak | _____ |
| CPU/Memoria | ⬜ Ondo ⬜ Kargatuta | _____ |
| Diskoa | ⬜ Ondo ⬜ Beteta | _____ |
| Sarea | ⬜ Ondo ⬜ Arazoak | _____ |
| Backup-ak | ⬜ Ondo ⬜ Arazoak | _____ |

### 11.2 Gomendatutako Ekintzak

1. _____
2. _____
3. _____

---

**Monitorizazio Txostenaren Sinadura:**

Teknikaria: _______________
Data: _______________
Hurrengo monitorizazioa: _______________