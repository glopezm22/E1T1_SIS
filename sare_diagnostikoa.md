# Sarearen Diagnostiko Txostena

**Data:** _______________
**Teknikaria:** _______________
**Zerbitzaria:** _______________

---

## 1. Sare Konfigurazioa

### 1.1 Interfaze Konfigurazioa

**Komandoa exekutatua:**
```bash
ip addr show
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Emaitza Taula:**

| Interfazea | IP Helbidea | Maskara | Egoera | MAC Helbidea |
|------------|-------------|---------|--------|--------------|
| ens18 | 192.168.201.X | /24 | UP | XX:XX:XX:XX:XX:XX |
| lo | 127.0.0.1 | /8 | UP | 00:00:00:00:00:00 |

**Ondorioak:**
- ✅ IP helbidea ondo konfiguratuta: 192.168.201.X
- ✅ Sare interfazea aktibo (UP)
- ✅ Loopback interfazea ondo konfiguratuta
- ⚠️ Arazoak (badaude): _________________

---

### 1.2 Routing Taula

**Komandoa exekutatua:**
```bash
ip route show
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Emaitza:**
```
default via 192.168.201.1 dev ens18
192.168.201.0/24 dev ens18 proto kernel scope link src 192.168.201.X
```

**Ondorioak:**
- ✅ Gateway ondo konfiguratuta: 192.168.201.1
- ✅ Sare lokala ondo definituta
- ⚠️ Arazoak: _________________

---

## 2. Konektibitate Probak

### 2.1 Gateway Proba

**Komandoa exekutatua:**
```bash
ping -c 4 192.168.201.1
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Emaitzak:**

| Metrika | Balioa |
|---------|--------|
| Pakete bidaliak | 4 |
| Pakete jasotakoak | 4 |
| Galera ehunekoa | 0% |
| RTT min/avg/max | X/X/X ms |

**Ondorioak:**
- ✅ Gateway-a iristegarria
- ✅ Ez dago pakete galerarik
- ✅ Latentzia normala (< 10ms)
- ⚠️ Arazoak: _________________

---

### 2.2 DNS Zerbitzariaren Proba

**Komandoa exekutatua:**
```bash
ping -c 4 8.8.8.8
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Emaitzak:**

| Metrika | Balioa |
|---------|--------|
| Pakete bidaliak | 4 |
| Pakete jasotakoak | 4 |
| Galera ehunekoa | 0% |
| RTT min/avg/max | X/X/X ms |

**Ondorioak:**
- ✅ DNS zerbitzaria iristegarria
- ✅ Internet konexioa funtzionatzen du
- ⚠️ Arazoak: _________________

---

### 2.3 DNS Ebazpen Proba

**Komandoa exekutatua:**
```bash
nslookup google.com
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Emaitza:**
```
Server:     8.8.8.8
Address:    8.8.8.8#53

Non-authoritative answer:
Name:   google.com
Address: 142.250.X.X
```

**Ondorioak:**
- ✅ DNS ebazpena ondo funtzionatzen du
- ✅ Domeinuak ondo ebazten dira
- ⚠️ Arazoak: _________________

---

### 2.4 Kanpoko Konexio Proba

**Komandoa exekutatua:**
```bash
ping -c 4 google.com
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Emaitzak:**

| Metrika | Balioa |
|---------|--------|
| Pakete bidaliak | 4 |
| Pakete jasotakoak | 4 |
| Galera ehunekoa | 0% |
| RTT min/avg/max | X/X/X ms |

**Ondorioak:**
- ✅ Internet konexioa ondo funtzionatzen du
- ✅ DNS + routing guztia ondo
- ⚠️ Arazoak: _________________

---

## 3. Portu eta Zerbitzuen Egoera

### 3.1 Entzuten Dauden Portuak

**Komandoa exekutatua:**
```bash
sudo ss -tuln
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Portuen Taula:**

| Protokoloa | Portua | Egoera | Zerbitzua | Notas |
|------------|--------|--------|-----------|-------|
| TCP | 22 | LISTEN | SSH | ✅ Aktibatuta |
| TCP | 21 | LISTEN | FTP | ✅ Aktibatuta |
| TCP | 80 | LISTEN | HTTP | ✅ Aktibatuta |
| TCP | 443 | LISTEN | HTTPS | ⚠️ Konfiguratu gabe |

**Ondorioak:**
- ✅ SSH portua (22) entzuten
- ✅ FTP portua (21) entzuten
- ✅ HTTP portua (80) entzuten
- ⚠️ Beste arazoak: _________________

---

### 3.2 Konexio Aktiboak

**Komandoa exekutatua:**
```bash
sudo ss -tan | head -20
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Konexio kopurua egoeraren arabera:**

| Egoera | Konexio Kopurua |
|--------|-----------------|
| ESTAB | X |
| TIME-WAIT | X |
| LISTEN | X |
| SYN-SENT | X |

**Ondorioak:**
- ✅ Konexio kopuru normala
- ✅ Ez dago konexio anomalorik
- ⚠️ Arazoak: _________________

---

## 4. Firewall Konfigurazioa

### 4.1 UFW Egoera

**Komandoa exekutatua:**
```bash
sudo ufw status verbose
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Arau Taula:**

| Portua/Zerbitzua | Ekintza | Noiztik | Notas |
|------------------|---------|---------|-------|
| 22/tcp (SSH) | ALLOW | Anywhere | ✅ |
| 21/tcp (FTP) | ALLOW | Anywhere | ✅ |
| 80/tcp (HTTP) | ALLOW | Anywhere | ✅ |
| 443/tcp (HTTPS) | ALLOW | Anywhere | ⚠️ |

**Ondorioak:**
- ✅ Firewall aktibatuta
- ✅ Beharrezko portuak irekita
- ⚠️ Arazoak: _________________

---

## 5. Errendimendu Probak

### 5.1 Bandwidth Proba (iperf3)

**Komandoa exekutatua:**
```bash
iperf3 -c ZERBITZARIA
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Emaitzak:**

| Metrika | Balioa |
|---------|--------|
| Bandwidth | XX Mbits/sec |
| Transfer | XX MBytes |
| Retransmissions | XX |

**Ondorioak:**
- ✅ Bandwidth esperatua
- ✅ Transfer egonkorra
- ⚠️ Arazoak: _________________

---

### 5.2 Latentzia Proba

**Komandoa exekutatua:**
```bash
ping -c 100 192.168.201.1
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Estatistikak:**

| Metrika | Balioa |
|---------|--------|
| Pakete kopurua | 100 |
| Galera % | X% |
| RTT min | X ms |
| RTT avg | X ms |
| RTT max | X ms |
| RTT mdev | X ms |

**Ondorioak:**
- ✅ Latentzia baxua
- ✅ Galera txikia (< 1%)
- ⚠️ Arazoak: _________________

---

### 5.3 Traceroute Analisia

**Komandoa exekutatua:**
```bash
traceroute google.com
```

**Pantaila-argazkia:**
```
[HEMEN TXERTATU PANTAILA-ARGAZKIA]
```

**Emaitzak:**

| Hop | IP Helbidea | Hostname | RTT |
|-----|-------------|----------|-----|
| 1 | 192.168.201.1 | Gateway | X ms |
| 2-N | ... | ... | X ms |

**Ondorioak:**
- ✅ Bidea normala
- ✅ Ez dago timeout-ik
- ⚠️ Arazoak: _________________

---

## 6. Ondorio Orokorrak

### 6.1 Egoera Laburpena

| Proba | Egoera | Azalpenak |
|-------|--------|-----------|
| IP Konfigurazioa | ✅ Ondo | IP estatikoa ondo konfiguratuta |
| Gateway Konexioa | ✅ Ondo | Gateway-ra iristen da |
| DNS Ebazpena | ✅ Ondo | Domeinuak ondo ebazten dira |
| Internet Konexioa | ✅ Ondo | Kanpoko zerbitzariak iristegarriak |
| Zerbitzu Portuak | ✅ Ondo | Beharrezko portuak irekita |
| Firewall | ✅ Ondo | Arauak ondo konfiguratuta |
| Errendimendua | ✅ Ondo | Bandwidth eta latentzia normalak |

### 6.2 Detektatutako Arazoak

1. **Arazo deskribapena 1:**
   - Arrazoia: _________________
   - Konponketa proposatua: _________________
   - Lehentasuna: Alta/Ertaina/Baxua

2. **Arazo deskribapena 2:**
   - Arrazoia: _________________
   - Konponketa proposatua: _________________
   - Lehentasuna: Alta/Ertaina/Baxua

### 6.3 Hobekuntza Gomendioak

1. _________________
2. _________________
3. _________________

---

## 7. Eranskinak

### 7.1 Sare Diagrama

```
[HEMEN TXERTATU SARE DIAGRAMA]

Internet
    ↓
Gateway (192.168.201.1)
    ↓
Switch/Router
    ↓
Zerbitzaria (192.168.201.X)
```

### 7.2 Komando Erabilgarriak

```bash
# Sare egoera
ip addr show
ip route show
ip link show

# Konektibitate
ping -c 4 IP
traceroute DOMAIN
mtr DOMAIN

# Portuak
ss -tuln
netstat -tuln
nmap localhost

# DNS
nslookup DOMAIN
dig DOMAIN
host DOMAIN

# Firewall
sudo ufw status
sudo iptables -L

# Errendimendua
iperf3 -s
iperf3 -c SERVER
```

---

**Txostenaren Sinadura:**

Teknikaria: _______________
Data: _______________
Sinadura: _______________