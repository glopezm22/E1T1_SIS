# Zerbitzariaren Konfigurazio eta Administrazio Proiektua

## 📋 Aurkibidea

1. [Sistema Eragilearen Instalazioa](#sistema-eragilearen-instalazioa)
2. [Sare Konfigurazioa](#sare-konfigurazioa)
3. [Erabiltzaileak eta Baimenak](#erabiltzaileak-eta-baimenak)
4. [Zerbitzuen Monitorizazioa](#zerbitzuen-monitorizazioa)
5. [Script-ak eta Automatizazioa](#script-ak-eta-automatizazioa)
6. [Sarearen Diagnostikoa](#sarearen-diagnostikoa)
7. [Aplikazioa Hedatzeko Pausuak](#aplikazioa-hedatzeko-pausuak)

---

## 🖥️ Sistema Eragilearen Instalazioa

### Proxmox VE Instalazioa

#### Aurrebaldintzak
- **Hardware eskakizunak:**
  - CPU: 64-bit prozesadorea (Intel edo AMD VT onartzen duena)
  - RAM: Gutxienez 4GB (gomendatua 8GB edo gehiago)
  - Diskoa: Gutxienez 32GB
  - Sare txartela: Gigabit Ethernet

#### Instalazio Pausuak

1. **ISO Irudia Deskargatu**
   ```bash
   # Deskargatu Proxmox VE ISOs hemen:
   https://www.proxmox.com/en/downloads
   ```

2. **USB Booteable Bat Sortu**
   - Windows: Rufus edo Etcher erabili
   - Linux: `dd` komandoa erabili
   ```bash
   sudo dd if=proxmox-ve_*.iso of=/dev/sdX bs=1M status=progress
   ```

3. **Instalatu Proxmox VE**
   - USB-tik abiatu
   - Hizkuntza aukeratu
   - Lizentzia onartu (EULA)
   - Disko gogorra aukeratu
   - Herrialdea, timezone eta teklatu-diseinua konfiguratu
   - Root pasahitza ezarri eta email helbidea sartu
   - Sare konfigurazioa ezarri (aldi baterako DHCP erabil dezakezu)
   - Instalatu eta berrabiarazi

4. **Web Interfazera Sartu**
   - Nabigatzailean ireki: `https://IP-HELBIDEA:8006`
   - Erabiltzailea: `root`
   - Pasahitza: Instalazioan ezarri duzuna

### Makina Birtual Berria Sortu

#### GUI Bidez

1. **Proxmox web interfazean:**
   - Klik egin `Create VM` botoian (goiko eskuinean)

2. **General Tab:**
   - Node: zure nodoa hautatu
   - VM ID: automatikoki esleituko da (adib. 100)
   - Name: `servidor-web` edo antzekoa

3. **OS Tab:**
   - ISO Image: Debian edo Ubuntu ISO bat aukeratu
   - Guest OS: Linux aukeratu
   - Version: zure aukeratutako bertsioa

4. **System Tab:**
   - Graphic card: Default (SPICE)
   - SCSI Controller: VirtIO SCSI
   - Qemu Agent: aktibatu (gomendatua)

5. **Disks Tab:**
   - Bus/Device: SCSI
   - Storage: local-lvm
   - Disk size: 20-50 GB (zure beharraren arabera)
   - Cache: Write back (aukerakoa)

6. **CPU Tab:**
   - Cores: 2-4 (gomendatua)
   - Type: host (onena errendimendurako)

7. **Memory Tab:**
   - Memory (MiB): 2048-4096 (2-4 GB)
   - Minimum memory: 512
   - Ballooning Device: aktibatu

8. **Network Tab:**
   - Bridge: vmbr0
   - Model: VirtIO (paravirtualized)
   - MAC address: auto

9. **Confirm:**
   - Klik egin `Finish`
   - Markatu `Start after created`

#### Makina Birtual Abiatu eta Sistema Eragilea Instalatu

1. **VM-a abiarazi:**
   - Hautatu VM-a ezkerreko menuan
   - Klik egin `Start` botoian
   - Klik egin `Console` ikustera joateko

2. **Debian/Ubuntu Instalazioa:**
   - Jarraitu instalazioaren pausuak
   - Hizkuntza: Euskara (edo nahiago duzuna)
   - Partizioak: "Erabili disko osoa" (bakarra bada)
   - Root pasahitza ezarri
   - Erabiltzaile normala sortu
   - Software hautaketa: SSH server eta oinarrizko sistemako utilitateak

3. **Instalazio ondoren:**
   ```bash
   # Eguneratu sistema
   sudo apt update && sudo apt upgrade -y
   
   # Instalatu oinarrizko tresnak
   sudo apt install -y vim curl wget git htop net-tools
   ```

---

## 🌐 Sare Konfigurazioa

### Sare Parametroak

| Parametroa | Balioa |
|------------|--------|
| IP Helbidea | 192.168.201.X |
| Sare Maskara | 255.255.255.0 (/24) |
| Gateway | 192.168.201.1 |
| DNS | 8.8.8.8 |

### Sare Konfigurazio Estatikoa (Debian/Ubuntu)

#### 1. Netplan Erabiliz (Ubuntu 18.04+)

Editatu `/etc/netplan/01-netcfg.yaml` fitxategia:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens18:  # Zure interfaze izena egiaztatu: ip link show
      dhcp4: no
      addresses:
        - 192.168.201.10/24  # Aldatu zure IP-ra
      routes:
        - to: default
          via: 192.168.201.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

Aplikatu konfigurazioa:
```bash
sudo netplan apply
```

#### 2. Interfaces Fitxategia Erabiliz (Debian edo zaharragoak)

Editatu `/etc/network/interfaces` fitxategia:

```bash
# Loopback interfazea
auto lo
iface lo inet loopback

# Sare interfaze nagusia
auto ens18
iface ens18 inet static
    address 192.168.201.10
    netmask 255.255.255.0
    gateway 192.168.201.1
    dns-nameservers 8.8.8.8 8.8.4.4
```

Berrabiarazi sare zerbitzua:
```bash
sudo systemctl restart networking
```

### Konexioa Egiaztatu

```bash
# IP konfigurazioa ikusi
ip addr show

# Gateway-a frogatu
ping -c 4 192.168.201.1

# Internet konexioa frogatu
ping -c 4 8.8.8.8

# DNS konexioa frogatu
ping -c 4 google.com

# Sare interfaze guztiak ikusi
ip link show

# Routing taula ikusi
ip route show
```

### Firewall Konfigurazio Oinarrizkoa (ufw)

```bash
# UFW instalatu eta gaitu
sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Beharrezko portuak ireki
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 21/tcp    # FTP
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS

# Gaitu firewall-a
sudo ufw enable

# Egoera ikusi
sudo ufw status verbose
```

---

## 👥 Erabiltzaileak eta Baimenak

### Erabiltzaile Konfigurazioaren Laburpena

| Erabiltzailea | Helburua | SSH | FTP | Karpeta Nagusia |
|---------------|----------|-----|-----|-----------------|
| **frontuser** | Frontend fitxategiak FTP bidez | ❌ Debekatuta | ✅ Baimenduta | /home/frontuser/web |
| **backuser** | Backend fitxategiak SSH/GIT bidez | ✅ Baimenduta | ❌ Debekatuta | /home/backuser/app |

### Erabiltzaileak Sortu

#### 1. frontuser sortu (FTP soilik)

```bash
# Erabiltzailea sortu
sudo adduser frontuser

# Pasahitza ezarri eta informazioa bete
# Pasahitza: [zure pasahitz segurua]

# Web direktorioa sortu
sudo mkdir -p /home/frontuser/web
sudo chown frontuser:frontuser /home/frontuser/web
sudo chmod 755 /home/frontuser/web

# SSH sarbidea debekatu
# Editatu /etc/ssh/sshd_config eta gehitu:
echo "DenyUsers frontuser" | sudo tee -a /etc/ssh/sshd_config

# SSH zerbitzua berrabiarazi
sudo systemctl restart sshd
```

#### 2. backuser sortu (SSH/GIT soilik)

```bash
# Erabiltzailea sortu
sudo adduser backuser

# Pasahitza ezarri
# Pasahitza: [zure pasahitz segurua]

# App direktorioa sortu
sudo mkdir -p /home/backuser/app
sudo chown backuser:backuser /home/backuser/app
sudo chmod 755 /home/backuser/app

# Git instalatu
sudo apt install git -y

# Git konfiguratu backuser-entzat
sudo -u backuser git config --global user.name "backuser"
sudo -u backuser git config --global user.email "backuser@localhost"
```

### FTP Zerbitzariaren Konfigurazioa (vsftpd)

#### Instalatu vsftpd

```bash
sudo apt update
sudo apt install vsftpd -y
```

#### Konfiguratu vsftpd

Editatu `/etc/vsftpd.conf` fitxategia:

```bash
# Oinarrizko konfigurazioa
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES

# Segurtasuna
chroot_local_user=YES
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd

# Erabiltzaile zerrenda
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO

# Passive mode konfigurazioa
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40100

# Errendimendua
ftpd_banner=Ongi etorri FTP zerbitzarira
```

#### Erabiltzaile zerrenda konfiguratu

```bash
# Soilik frontuser-i eman FTP sarbidea
echo "frontuser" | sudo tee /etc/vsftpd.userlist

# Berrabiarazi zerbitzua
sudo systemctl restart vsftpd
sudo systemctl enable vsftpd
```

### SSH Konfigurazio Segurua

Editatu `/etc/ssh/sshd_config`:

```bash
# Oinarrizko segurtasuna
PermitRootLogin no
PasswordAuthentication yes
PubkeyAuthentication yes
PermitEmptyPasswords no

# frontuser-i debekatu SSH
DenyUsers frontuser

# Soilik backuser eta zure admin erabiltzailea
AllowUsers backuser zure-admin-erabiltzailea

# Port aldatu (aukerakoa, segurtasunerako)
# Port 2222
```

Berrabiarazi SSH:
```bash
sudo systemctl restart sshd
```

### Baimenak Egiaztatu

```bash
# frontuser direktorioen baimenak
ls -la /home/frontuser/

# backuser direktorioen baimenak
ls -la /home/backuser/

# Frogatu FTP konexioa (beste terminal batetik)
ftp localhost
# Erabiltzailea: frontuser
# Pasahitza: [frontuser-en pasahitza]

# Frogatu SSH konexioa
ssh backuser@localhost
```

---

## 📊 Zerbitzuen Monitorizazioa

### Sistemaren Baliabideen Egoera

#### 1. top / htop - Prozesuen Jarraipena

**top komandoa:**
```bash
top
```

**Informazioa:**
- **1. lerroa (uptime)**: Sistema noiz abiarazi zen eta erabiltzaile kopurua
- **2. lerroa (Tasks)**: Prozesu kopurua eta egoera (running, sleeping, stopped, zombie)
- **3. lerroa (CPU)**: CPU erabilera ehunekoa
  - `us`: user (erabiltzaile prozesuen CPU)
  - `sy`: system (sistemaren prozesuen CPU)
  - `id`: idle (libre dagoen CPU)
  - `wa`: wait (I/O itxaroten)
- **4. lerroa (Memory)**: RAM erabileraren zehaztapena
- **5. lerroa (Swap)**: Swap memoria erabileraren zehaztapena
- **Prozesu zerrenda**: CPU edo memoria gehien erabiltzen duten prozesuen zerrenda

**htop komandoa (hobetua):**
```bash
# Instalatu behar bada
sudo apt install htop -y

# Exekutatu
htop
```

**htop-en abantailak:**
- Interfaze koloreduna eta erabilgarriagoa
- Mouse onarpena
- Prozesuak zuzenean kudeatu (F9 kill, F7/F8 priority)
- CPU core guztiak ikusi
- Prozesuen zuhaitz-ikuspegia (F5)

**Tekla erabilgarriak:**
- `F1`: Laguntza
- `F3`: Bilatu prozesua
- `F4`: Filtratu
- `F5`: Zuhaitz-ikuspegia
- `F6`: Ordenatu (CPU, MEM, PID...)
- `F9`: Kill prozesua
- `F10`: Irten
- `Space`: Markatu prozesua

#### 2. df -h - Diskoko Partizioen Erabilera

```bash
df -h
```

**Erakusten den informazioa:**
- **Filesystem**: Partizioaren izena
- **Size**: Partizioaren tamaina osoa
- **Used**: Erabilitako espazioa
- **Avail**: Erabilgarri dagoen espazioa
- **Use%**: Erabileraren ehunekoa
- **Mounted on**: Mount puntua (non erakusten den fitxategi sisteman)

**Gomendatutako balioak:**
- ✅ < 70%: Egoera ona
- ⚠️ 70-85%: Kontu izan
- ❌ > 85%: Espazioa liberatu behar da

**Adibidea:**
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        20G  8.5G   11G  44% /
/dev/sda2        50G   15G   33G  32% /home
```

#### 3. free -h - Memoria Erabilera

```bash
free -h
```

**Erakusten den informazioa:**
- **total**: Memoria osoa
- **used**: Erabilitako memoria (programa aktiboak)
- **free**: Erabiltzen ez den memoria
- **shared**: Prozesu askoren artean partekatutako memoria
- **buff/cache**: Cache-rako erabilitako memoria (errendimendua hobetzeko)
- **available**: Erabilgarri dagoen memoria benetan (cache-a kontuan hartuta)

**Swap memoria:**
- Diskoan gordetako memoria (RAM-a bete denean)
- Swap erabilera handia = RAM-aren presioa

**Interpretazioa:**
```
              total        used        free      shared  buff/cache   available
Mem:           3.8Gi       1.2Gi       1.8Gi        50Mi       800Mi       2.4Gi
Swap:          2.0Gi          0B       2.0Gi
```

- Memoria disponible ona: > 20% total-etik
- Swap konstanteki erabiltzen bada: RAM gehiago behar da

#### 4. uptime - Sistemaren Funtzionamendu-denbora

```bash
uptime
```

**Adibidea:**
```
14:30:25 up 5 days, 3:15, 2 users, load average: 0.52, 0.58, 0.59
```

**Informazioa:**
- **14:30:25**: Ordu aktuala
- **up 5 days, 3:15**: Sistema 5 egun eta 3 ordu martxan
- **2 users**: 2 erabiltzaile konektatuta
- **load average**: Sistemaren karga batez-bestekoa
  - 1. balioa: azken minutuko karga
  - 2. balioa: azken 5 minutuko karga
  - 3. balioa: azken 15 minutuko karga

**Load average interpretazioa:**
- 1 core-ko sistema:
  - < 1.0: Ondo
  - 1.0-2.0: Kargatuta
  - > 2.0: Gainkargatuta
- 4 core-ko sistema:
  - < 4.0: Ondo
  - 4.0-8.0: Kargatuta
  - > 8.0: Gainkargatuta

#### 5. iostat - Diskoko I/O Errendimendua (aukerakoa)

```bash
# Instalatu behar bada
sudo apt install sysstat -y

# Exekutatu
iostat -x 1
```

**Informazio garrantzitsuena:**
- **%util**: Diskoa lan egiten ari den denbora ehunekoa
  - < 70%: Ondo
  - 70-90%: Kargatuta
  - > 90%: Eragozpen handia (bottleneck)
- **r/s**: Irakurketa eragiketa segundoko
- **w/s**: Idazketa eragiketa segundoko
- **await**: Batez-besteko itxaron-denbora milisegundotan

### Zerbitzuen Egoera

#### Komandoak Zerbitzuen Egoera Ikusteko

```bash
# SSH zerbitzua
sudo systemctl status ssh

# VSFTPD zerbitzua (FTP)
sudo systemctl status vsftpd

# Apache2 zerbitzua (web)
sudo systemctl status apache2

# Zerbitzu guztien laburpena
sudo systemctl list-units --type=service --state=running
```

#### Zerbitzu Egoeren Taula

| Zerbitzua | Komandoa | Egoera Esperatua | Portua |
|-----------|----------|------------------|--------|
| SSH | `systemctl status ssh` | ✅ active (running) | 22 |
| VSFTPD | `systemctl status vsftpd` | ✅ active (running) | 21 |
| Apache2 | `systemctl status apache2` | ✅ active (running) | 80, 443 |

#### Systemctl Komandoak

```bash
# Zerbitzua ikusi
sudo systemctl status ZERBITZUA

# Zerbitzua hasi
sudo systemctl start ZERBITZUA

# Zerbitzua gelditu
sudo systemctl stop ZERBITZUA

# Zerbitzua berrabiarazi
sudo systemctl restart ZERBITZUA

# Zerbitzua sisteman abiaraztean gaitu
sudo systemctl enable ZERBITZUA

# Zerbitzua sisteman abiaraztean desgaitu
sudo systemctl disable ZERBITZUA

# Zerbitzuaren konfigurazioa birkargatu
sudo systemctl reload ZERBITZUA
```

#### Egoera Ikurrak

- 🟢 **active (running)**: Zerbitzua exekutatzen ari da
- 🟡 **inactive (dead)**: Zerbitzua geldirik dago
- 🔴 **failed**: Zerbitzuak errorea du
- 🔵 **enabled**: Sistemaren hasieran automatikoki abiaraziko da
- ⚪ **disabled**: Ez da automatikoki abiaraziko

---

## 🤖 Script-ak eta Automatizazioa

### backup.sh - Segurtasun Kopia Script-a

#### Deskribapena
Script honek direktorio jakin baten segurtasun kopia bat sortzen du `.tar.gz` formatuan, egungo data izena erabiliz.

#### Ezaugarriak
- ✅ Direktorio bat konprimitu eta babes-kopia egin
- ✅ Egungo datarekin fitxategia izendatu
- ✅ 30 egun baino zaharragoak diren backup-ak automatikoki ezabatu
- ✅ Log fitxategia sortu jarraipenerako
- ✅ Errore kudeaketa

#### Instalazioa

```bash
# Script-a deskargatu edo sortu
sudo nano /usr/local/bin/backup.sh

# Script-aren edukia kopiatu (ikus artifactua)

# Exekuzio baimenak eman
sudo chmod +x /usr/local/bin/backup.sh

# Backup direktorioa sortu
sudo mkdir -p /backup
```

#### Erabilera

```bash
# Eskuz exekutatu
sudo /usr/local/bin/backup.sh

# Emaitza:
# - Fitxategia: /backup/backup_20250119_143025.tar.gz
# - Log-a: /var/log/backup.log
```

#### Konfigurazioa

Script-aren hasieran aldatu ditzakezu aldagai hauek:

```bash
ITURRIA="/home/frontuser/web"    # Kopia egiteko direktorioa
HELMUGA="/backup"                 # Backup-ak gordetzeko lekua
```

### monitor.sh - Baliabideen Monitorizazio Script-a

#### Deskribapena
Script honek sistemaren baliabideen informazio osoa batzen du: CPU, memoria, diskoa, sarea eta zerbitzuak.

#### Ezaugarriak
- ✅ Informazio osoa batzen du sistema osotik
- ✅ Log fitxategi bakoitzean data izendatua
- ✅ 7 egun baino zaharragoak diren log-ak ezabatu
- ✅ Irakurgarria eta antolatua
- ✅ Kolore onarpena terminalean

#### Instalazioa

```bash
# Script-a sortu
sudo nano /usr/local/bin/monitor.sh

# Script-aren edukia kopiatu (ikus artifactua)

# Exekuzio baimenak eman
sudo chmod +x /usr/local/bin/monitor.sh

# Log direktorioa sortu
sudo mkdir -p /var/log/monitor
```

#### Erabilera

```bash
# Eskuz exekutatu
sudo /usr/local/bin/monitor.sh

# Emaitza ikusi
cat /var/log/monitor/monitor-$(date +%Y%m%d)*.log
```

### Cron Bidez Automatizazioa

#### Cron Sarrera Editatu

```bash
# Root erabiltzailearen crontab editatu
sudo crontab -e
```

#### Backup Automatikoa - Egunero Gaueko 2:00etan

```bash
# Backup script-a egunero 02:00etan exekutatu
0 2 * * * /usr/local/bin/backup.sh >> /var/log/backup-cron.log 2>&1
```

#### Monitorizazioa - Ordu erdiro

```bash
# Monitorizazioa ordu erdiro
30 * * * * /usr/local/bin/monitor.sh >> /var/log/monitor-cron.log 2>&1
```

#### Monitorizazioa - Egunero 08:00, 14:00 eta 20:00etan

```bash
# Monitorizazioa egunero 3 aldiz
0 8,14,20 * * * /usr/local/bin/monitor.sh >> /var/log/monitor-cron.log 2>&1
```

#### Cron Formatua

```
*     *     *     *     *     komandoa
│     │     │     │     │
│     │     │     │     └─── Asteko eguna (0-7, 0=igandea, 7=igandea)
│     │     │     └───────── Hilabetea (1-12)
│     │     └─────────────── Hileko eguna (1-31)
│     └───────────────────── Ordua (0-23)
└─────────────────────────── Minutua (0-59)
```

**Adibide gehiago:**
```bash
# Minuturo
* * * * * komandoa

# 5 minuturo
*/5 * * * * komandoa

# Astelehenero 09:00etan
0 9 * * 1 komandoa

# Hilabete hasieran
0 0 1 * * komandoa

# Lan egunetakoa 08:00-18:00 artean orduro
0 8-18 * * 1-5 komandoa
```

#### Cron Log-ak Ikusi

```bash
# Cron exekuzioak ikusi
sudo tail -f /var/log/syslog | grep CRON

# Edo
sudo journalctl -u cron -f
```

---

## 🔍 Sarearen Diagnostikoa

### Oinarrizko Sareko Egiaztapenak

#### 1. Sare Interfazea Ondo Konfiguratuta Dago?

```bash
# Interfaze guztiak ikusi
ip addr show

# edo
ifconfig

# Interfaze bat aktibatu
sudo ip link set ens18 up

# Interfaze bat desaktibatu
sudo ip link set ens18 down
```

**Egiaztatu beharreko puntuak:**
- ✅ Interfazea `UP` egoeran dago
- ✅ IP helbidea ondo esleituta
- ✅ Netmask zuzena

#### 2. Gateway-a Iristegarria da?

```bash
# Gateway-a ping egin
ping -c 4 192.168.201.1

# Traceroute-a egin gateway-raino
traceroute 192.168.201.1
```

#### 3. DNS Funtzionatzen al du?

```bash
# DNS zerbitzaria ping egin
ping -c 4 8.8.8.8

# Izen bat ebatzi
nslookup google.com

# edo
dig google.com

# Funtzionatzen ez badu, DNS konfigurazioa egiaztatu
cat /etc/resolv.conf
```

#### 4. Internet Konexioa Froga

```bash
# Kanpoko zerbitzari bat ping egin
ping -c 4 google.com

# Web orri bat deskargatu
curl -I https://www.google.com

# edo
wget --spider https://www.google.com
```

### Sare Diagnostiko Tresnak

#### netstat / ss - Konexio Aktiboak

```bash
# TCP konexio guztiak
ss -tan

# UDP konexioak
ss -uan

# Entzuten dauden portuak
ss -tuln

# Konexio zehatza bilatu
ss -tan | grep :80
```

#### nmap - Portuak Eskaneatu

```bash
# Instalatu
sudo apt install nmap -y

# Zure makina eskaneatu
nmap localhost

# Beste IP bat eskaneatu
nmap 192.168.201.1

# Zerbitzu-bertsio detekzioa
nmap -sV 192.168.201.10

# Sare osoa eskaneatu
nmap 192.168.201.0/24
```

#### tcpdump - Trafiko Analisia

```bash
# Instalatu
sudo apt install tcpdump -y

# Interfaze batean trafikoa ikusi
sudo tcpdump -i ens18

# HTTP trafikoa bakarrik
sudo tcpdump -i ens18 port 80

# Fitxategian gorde
sudo tcpdump -i ens18 -w capture.pcap

# Irakurri captura
sudo tcpdump -r capture.pcap
```

### Sare Errendimendua Neurtu

#### iperf3 - Bandwidth Testa

```bash
# Instalatu
sudo apt install iperf3 -y

# Zerbitzari moduan (makina 1)
iperf3 -s

# Bezero moduan (makina 2)
iperf3 -c IP_ZERBITZARIA

# UDP proba
iperf3 -c IP_ZERBITZARIA -u -b 100M
```

#### mtr - Traceroute Hobetua

```bash
# Instalatu
sudo apt install mtr -y

# Exekutatu
mtr google.com

# Txosten moduan
mtr --report google.com
```

### Sare Arazo Arruntak

#### Arazo: Ez dut konexiorik

```bash
# 1. Sare interfazea ondo dago?
ip link show

# 2. IP konfigurazioa ondo dago?
ip addr show

# 3. Gateway-a iristegarria da?
ping -c 4 192.168.201.1

# 4. DNS funtzionatzen du?
ping -c 4 8.8.8.8

# 5. Firewall blokeatzen ari da?
sudo ufw status
```

#### Arazo: Konexio motelak

```bash
# 1. Sare karga ikusi
iftop  # Instalatu: sudo apt install iftop

# 2. Latentzia neurtu
ping -c 10 192.168.201.1

# 3. Bandwidth neurtu
iperf3 -c ZERBITZARIA

# 4. DNS errendimendua
dig google.com
```

#### Arazo: Zerbitzuak ez dira iristegarriak

```bash
# 1. Zerbitzua martxan dago?
sudo systemctl status apache2

# 2. Portua entzuten ari da?
sudo ss -tuln | grep :80

# 3. Firewall irekita dago?
sudo ufw status | grep 80

# 4. Kanpotik konektatu daiteke?
telnet localhost 80
```

---

## 🚀 Aplikazioa Hedatzeko Pausuak

### Frontend Hedapena (frontuser FTP bidez)

#### 1. Prestatu Frontend Lokala

```bash
# Lokala: Build egin frontend-a
cd /zure/frontend/proiektua
npm run build
# edo
yarn build
```

#### 2. FTP Bidez Igo

**FileZilla erabiliz (GUI):**
1. Ireki FileZilla
2. Host: zure-zerbitzaria.com
3. Username: frontuser
4. Password: frontuser-en pasahitza
5. Port: 21
6. Klik "Quickconnect"
7. Kargatu `dist/` edo `build/` karpeta `/home/frontuser/web/` direktoriora

**Komando lerrotik (lftp):**
```bash
# Instalatu lftp
sudo apt install lftp

# Konektatu
lftp ftp://frontuser@zure-ip

# Pasahitza sartu

# Kargatu fitxategiak
mirror -R /local/build/ /home/frontuser/web/

# Irten
bye
```

#### 3. Egiaztatu Web Zerbitzarian

```bash
# SSH bidez konektatu (admin gisa)
ssh admin@zure-ip

# Egiaztatu fitxategiak iritsi direla
ls -la /home/frontuser/web/

# Baimenak egiaztatu
sudo chown -R www-data:www-data /home/frontuser/web/
sudo chmod -R 755 /home/frontuser/web/
```

### Backend Hedapena (backuser SSH/GIT bidez)

#### 1. Git Repository Konfiguratu

**GitHub-en:**
1. Sortu repository berria
2. Kargatu zure backend kodea

#### 2. Zerbitzarian Git Clone Egin

```bash
# SSH bidez konektatu backuser gisa
ssh backuser@zure-ip

# Joan app direktoriora
cd /home/backuser/app

# Clone egin repository-a
git clone https://github.com/zure-erabiltzailea/backend-app.git .

# Edo SSH key bidez
git clone git@github.com:zure-erabiltzailea/backend-app.git .
```

#### 3. SSH Key-ak Konfiguratu (aukerakoa baina gomendatua)

```bash
# Zerbitzarian, backuser gisa:
ssh-keygen -t ed25519 -C "backuser@zerbitzaria"

# Public key-a kopiatu
cat ~/.ssh/id_ed25519.pub

# GitHub-en:
# Settings → SSH and GPG keys → New SSH key
# Title: "Zerbitzariaren SSH Key"
# Key: Kopiatu key-a

# Frogatu
ssh -T git@github.com
```

#### 4. Backend Dependentziak Instalatu

**Node.js aplikazioa:**
```bash
cd /home/backuser/app

# Instalatu dependentziak
npm install

# Edo production moduan
npm ci --only=production

# Konfiguratu environment aldagaiak
nano .env

# Proba egin
npm start
```

**Python aplikazioa:**
```bash
cd /home/backuser/app

# Virtual environment sortu
python3 -m venv venv
source venv/bin/activate

# Instalatu dependentziak
pip install -r requirements.txt

# Proba egin
python app.py
```

#### 5. Aplikazioa Zerbitzu Gisa Konfiguratu

**Systemd service sortu:**
```bash
sudo nano /etc/systemd/system/backend-app.service
```

**Edukia (Node.js adibidea):**
```ini
[Unit]
Description=Backend Application
After=network.target

[Service]
Type=simple
User=backuser
WorkingDirectory=/home/backuser/app
ExecStart=/usr/bin/node /home/backuser/app/server.js
Restart=on-failure
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=backend-app

Environment=NODE_ENV=production
Environment=PORT=3000

[Install]
WantedBy=multi-user.target
```

**Aktibatu zerbitzua:**
```bash
# Reload systemd
sudo systemctl daemon-reload

# Hasi zerbitzua
sudo systemctl start backend-app

# Gaitu hasieran
sudo systemctl enable backend-app

# Egiaztatu egoera
sudo systemctl status backend-app

# Log-ak ikusi
sudo journalctl -u backend-app -f
```

### Eguneraketa Prozesua

#### Frontend Eguneratu

```bash
# Lokala: Build berria
cd /zure/frontend/proiektua
npm run build

# FTP bidez igo (aurreko pausuak errepikatu)
```

#### Backend Eguneratu

```bash
# SSH bidez konektatu
ssh backuser@zure-ip

# Joan app direktoriora
cd /home/backuser/app

# Aldaketak deskargatu
git pull origin main

# Dependentziak eguneratu (beharrezkoa bada)
npm install

# Zerbitzua berrabiarazi
sudo systemctl restart backend-app

# Egiaztatu ondo dabilela
sudo systemctl status backend-app
```

### Nginx Reverse Proxy Konfigurazioa (gomendatua)

```bash
# Instalatu nginx
sudo apt install nginx -y

# Konfiguratu site berria
sudo nano /etc/nginx/sites-available/zure-app
```

**Konfigurazio adibidea:**
```nginx
server {
    listen 80;
    server_name zure-domeinua.com;

    # Frontend (static fitxategiak)
    location / {
        root /home/frontuser/web;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # Backend API
    location /api {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

**Aktibatu konfigurazioa:**
```bash
# Sortu symlink
sudo ln -s /etc/nginx/sites-available/zure-app /etc/nginx/sites-enabled/

# Frogatu konfigurazioa
sudo nginx -t

# Berrabiarazi nginx
sudo systemctl restart nginx

# Gaitu hasieran
sudo systemctl enable nginx
```

---

## 📝 Laburpena

### Proiektuaren Egitura

```
/
├── /home/
│   ├── frontuser/
│   │   └── web/          # Frontend fitxategiak (FTP)
│   └── backuser/
│       └── app/          # Backend fitxategiak (Git)
├── /backup/              # Segurtasun kopiak
├── /var/log/
│   ├── monitor/          # Monitorizazio log-ak
│   └── backup.log        # Backup log-a
└── /usr/local/bin/
    ├── backup.sh         # Backup script-a
    └── monitor.sh        # Monitorizazio script-a
```

### Komando Laburpen Taula

| Ekintza | Komandoa |
|---------|----------|
| Sistema informazioa | `uname -a` |
| Prozesuen jarraipena | `top` edo `htop` |
| Memoria egoera | `free -h` |
| Diskoa egoera | `df -h` |
| Uptime ikusi | `uptime` |
| Zerbitzu egoera | `systemctl status ZERBITZUA` |
| Sare konfigurazioa | `ip addr show` |
| Gateway ping | `ping -c 4 192.168.201.1` |
| Backup eskuz | `/usr/local/bin/backup.sh` |
| Monitorizazioa eskuz | `/usr/local/bin/monitor.sh` |
| Cron editatu | `sudo crontab -e` |
| Log-ak ikusi | `tail -f /var/log/syslog` |

### Tresna Erabilgarriak

```bash
# Sistema monitorizazioa
htop          # Prozesu jarraipena
iotop         # I/O jarraipena  
iftop         # Sare trafikoa
glances       # Monitorizazio osoa

# Sareko tresnak
nmap          # Portu eskaneatzailea
tcpdump       # Pakete analisia
mtr           # Traceroute hobetua
iperf3        # Bandwidth testa

# Log analisia
journalctl    # Systemd log-ak
dmesg         # Kernel mezuak
tail -f       # Log jarraipena

# Fitxategi kudeaketa
ncdu          # Diskoko erabilera (interaktiboa)
rsync         # Fitxategi sinkronizazioa
```

---

## ❓ Ohiko Arazoen Konponketa

### Arazo: Script-a ez da exekutatzen

**Konponketa:**
```bash
# Egiaztatu baimenak
ls -l /usr/local/bin/backup.sh

# Eman exekuzio baimenak
sudo chmod +x /usr/local/bin/backup.sh

# Egiaztatu script-aren sintaxia
bash -n /usr/local/bin/backup.sh
```

### Arazo: Cron ez da exekutatzen

**Konponketa:**
```bash
# Cron log-ak ikusi
sudo tail -f /var/log/syslog | grep CRON

# Egiaztatu cron zerbitzua martxan dagoela
sudo systemctl status cron

# Berrabiarazi cron
sudo systemctl restart cron

# Script-ean bide absolutuak erabili
# OKERRA: df -h
# ZUZENA: /bin/df -h
```

### Arazo: FTP konexio arazoak

**Konponketa:**
```bash
# Egiaztatu vsftpd martxan dagoela
sudo systemctl status vsftpd

# Egiaztatu firewall-a
sudo ufw status | grep 21

# Log-ak ikusi
sudo tail -f /var/log/vsftpd.log

# Frogatu localetik
ftp localhost
```

### Arazo: SSH blokeoa

**Konponketa:**
```bash
# Egiaztatu SSH konfigurazioa
sudo sshd -t

# Ikusi zein erabiltzaile blokeatuta dauden
grep DenyUsers /etc/ssh/sshd_config

# Berrabiarazi SSH
sudo systemctl restart sshd
```

---

## 📚 Erreferentzia Gehigarriak

- [Debian Documentation](https://www.debian.org/doc/)
- [Ubuntu Server Guide](https://ubuntu.com/server/docs)
- [Proxmox VE Documentation](https://pve.proxmox.com/pve-docs/)
- [Bash Scripting Guide](https://tldp.org/LDP/abs/html/)
- [Cron HowTo](https://help.ubuntu.com/community/CronHowto)
- [vsftpd Documentation](https://security.appspot.com/vsftpd.html)

---

**Azken eguneraketa:** 2025-01-19
**Bertsioa:** 1.0
**Egilea:** [Zure izena]