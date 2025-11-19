# Erabiltzaile eta Baimenen Konfigurazio Gida

## 📋 Aurkibidea

1. [Erabiltzaile Ikuspegi Orokorra](#erabiltzaile-ikuspegi-orokorra)
2. [frontuser Konfigurazioa (FTP)](#frontuser-konfigurazioa-ftp)
3. [backuser Konfigurazioa (SSH/GIT)](#backuser-konfigurazioa-sshgit)
4. [Baimen Sistema](#baimen-sistema)
5. [FTP Zerbitzariaren Konfigurazio Zehatza](#ftp-zerbitzariaren-konfigurazio-zehatza)
6. [SSH Konfigurazio Segurua](#ssh-konfigurazio-segurua)
7. [Frogak eta Egiaztapenak](#frogak-eta-egiaztapenak)

---

## 1. Erabiltzaile Ikuspegi Orokorra

### 1.1 Erabiltzaile Eskema

```
┌─────────────────────────────────────────────────────────────┐
│                    ZERBITZARIAREN SARBIDEA                   │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────┐      ┌──────────────────────┐    │
│  │     frontuser        │      │      backuser        │    │
│  ├──────────────────────┤      ├──────────────────────┤    │
│  │ Sarbidea: FTP        │      │ Sarbidea: SSH + GIT  │    │
│  │ SSH: ❌ Debekatuta   │      │ FTP: ❌ Debekatuta   │    │
│  │ Karpeta:             │      │ Karpeta:             │    │
│  │ /home/frontuser/web  │      │ /home/backuser/app   │    │
│  │                      │      │                      │    │
│  │ Erabilera:           │      │ Erabilera:           │    │
│  │ - Frontend igotze    │      │ - Backend igotze     │    │
│  │ - HTML/CSS/JS        │      │ - Git clone/pull     │    │
│  │ - Irudi fitxategiak  │      │ - Kodea garatu       │    │
│  └──────────────────────┘      └──────────────────────┘    │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              admin (Administrazio)                    │   │
│  ├──────────────────────────────────────────────────────┤   │
│  │ Sarbidea: SSH (sudo baimenekin)                      │   │
│  │ Erabilera: Sistema administrazioa                    │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Erabiltzaile Laburpen Taula

| Erabiltzailea | SSH | FTP | SUDO | Karpeta Nagusia | Helburua |
|---------------|-----|-----|------|-----------------|----------|
| **admin** | ✅ | ❌ | ✅ | /home/admin | Sistema administrazioa |
| **frontuser** | ❌ | ✅ | ❌ | /home/frontuser/web | Frontend igotze (FTP) |
| **backuser** | ✅ | ❌ | ❌ | /home/backuser/app | Backend garapen (Git) |

---

## 2. frontuser Konfigurazioa (FTP)

### 2.1 Erabiltzailea Sortu

```bash
# 1. Sortu erabiltzailea
sudo adduser frontuser

# Informazioa sartu:
# - Full Name: Frontend User
# - Room Number: [hutsik utzi]
# - Work Phone: [hutsik utzi]
# - Home Phone: [hutsik utzi]
# - Other: [hutsik utzi]

# 2. Pasahitza ezarri (GARRANTZITSUA: Pasahitz segurua erabili)
# Adibidez: Fr0nt3nd#2025$Secure
```

### 2.2 Web Direktorioa Sortu

```bash
# Sortu web direktorioa
sudo mkdir -p /home/frontuser/web

# Ezarri jabetza
sudo chown frontuser:frontuser /home/frontuser/web

# Ezarri baimenak
sudo chmod 755 /home/frontuser/web

# Sortu azpi-direktorioak (aukerakoa)
sudo mkdir -p /home/frontuser/web/{html,css,js,images,assets}
sudo chown -R frontuser:frontuser /home/frontuser/web/
sudo chmod -R 755 /home/frontuser/web/

# Egiaztatu egitura
tree /home/frontuser/web
```

**Direktorio egitura esperatua:**
```
/home/frontuser/web/
├── html/
├── css/
├── js/
├── images/
└── assets/
```

### 2.3 SSH Sarbidea Debekatu

**Aukera 1: DenyUsers erabili (Gomendatua)**

```bash
# Editatu SSH konfigurazio fitxategia
sudo nano /etc/ssh/sshd_config

# Gehitu lerro hau fitxategiaren amaieran:
DenyUsers frontuser

# Gorde eta itxi (Ctrl+X, Y, Enter)

# Berrabiarazi SSH zerbitzua
sudo systemctl restart sshd

# Egiaztatu konfigurazioa
sudo sshd -t
```

**Aukera 2: Shell aldatu nologin-era**

```bash
# Aldatu frontuser-en shell-a nologin-era
sudo usermod -s /usr/sbin/nologin frontuser

# Egiaztatu
grep frontuser /etc/passwd
# Emaitza: frontuser:x:1001:1001:Frontend User,,,:/home/frontuser:/usr/sbin/nologin
```

### 2.4 FTP Soilik Baimenduta

Ikus [FTP Zerbitzariaren Konfigurazio Zehatza](#5-ftp-zerbitzariaren-konfigurazio-zehatxa) atala.

---

## 3. backuser Konfigurazioa (SSH/GIT)

### 3.1 Erabiltzailea Sortu

```bash
# 1. Sortu erabiltzailea
sudo adduser backuser

# Informazioa sartu:
# - Full Name: Backend User
# - Room Number: [hutsik utzi]
# - Work Phone: [hutsik utzi]
# - Home Phone: [hutsik utzi]
# - Other: [hutsik utzi]

# 2. Pasahitza ezarri (GARRANTZITSUA: Pasahitz segurua erabili)
# Adibidez: B@ck3nd#2025$Secure
```

### 3.2 App Direktorioa Sortu

```bash
# Sortu app direktorioa
sudo mkdir -p /home/backuser/app

# Ezarri jabetza
sudo chown backuser:backuser /home/backuser/app

# Ezarri baimenak
sudo chmod 755 /home/backuser/app

# Sortu azpi-direktorioak (aukerakoa)
sudo mkdir -p /home/backuser/app/{src,config,logs}
sudo chown -R backuser:backuser /home/backuser/app/
sudo chmod -R 755 /home/backuser/app/

# Egiaztatu egitura
tree /home/backuser/app
```

### 3.3 Git Konfiguratu

```bash
# Git instalatu (ez badago)
sudo apt install git -y

# Aldatu backuser erabiltzailera
sudo su - backuser

# Git konfiguratu
git config --global user.name "Backend User"
git config --global user.email "backuser@zure-domeinua.com"

# Egiaztatu konfigurazioa
git config --list

# Irten backuser sesioa
exit
```

### 3.4 SSH Key Sortu (Aukerakoa baina Gomendatua)

```bash
# Aldatu backuser erabiltzailera
sudo su - backuser

# Sortu SSH key parea
ssh-keygen -t ed25519 -C "backuser@zerbitzaria"

# Enter sakatu pasahitzik gabe (edo jarri pasahitza segurtasunerako)
# Gordeko da: ~/.ssh/id_ed25519 (pribatua) eta ~/.ssh/id_ed25519.pub (publikoa)

# Ikusi public key-a
cat ~/.ssh/id_ed25519.pub

# Kopiatu key hau eta gehitu GitHub/GitLab-en:
# GitHub: Settings → SSH and GPG keys → New SSH key

# Frogatu konexioa
ssh -T git@github.com
# Emaitza esperatua: "Hi username! You've successfully authenticated..."

# Irten backuser sesioa
exit
```

### 3.5 FTP Sarbidea Debekatu

```bash
# Ziurtatu backuser ez dagoela FTP userlist-ean
sudo grep backuser /etc/vsftpd.userlist

# Ez badu ezer erakusten, ondo dago (ez dago zerrendan)

# Badago, ezabatu:
sudo sed -i '/^backuser$/d' /etc/vsftpd.userlist

# Berrabiarazi vsftpd
sudo systemctl restart vsftpd
```

---

## 4. Baimen Sistema

### 4.1 Linux Baimenen Azalpena

```
  rwx rwx rwx
  │││ │││ │││
  │││ │││ └┴┴─── Besteak (Others)
  │││ └┴┴───────  Taldea (Group)
  └┴┴─────────── Jabea (Owner)

r (read)    = 4
w (write)   = 2
x (execute) = 1
```

**Baimen arruntak:**

| Kodea | Baimena | Deskribapena |
|-------|---------|--------------|
| 755 | rwxr-xr-x | Jabeak dena, besteak irakurri/exekutatu |
| 644 | rw-r--r-- | Jabeak irakurri/idatzi, besteak irakurri |
| 700 | rwx------ | Jabeak soilik, besteak ezer ez |
| 600 | rw------- | Jabeak irakurri/idatzi soilik |
| 777 | rwxrwxrwx | Dena guztiontzat (ARRISKUTSUA, saihestu!) |

### 4.2 Direktorioen Baimenen Eskema

**frontuser (web karpeta):**
```bash
# Web direktorioa eta fitxategiak
sudo chown -R frontuser:frontuser /home/frontuser/web
sudo find /home/frontuser/web -type d -exec chmod 755 {} \;  # Direktorioak
sudo find /home/frontuser/web -type f -exec chmod 644 {} \;  # Fitxategiak

# Web zerbitzariak irakurtzeko (Apache/Nginx)
sudo chown -R frontuser:www-data /home/frontuser/web
```

**backuser (app karpeta):**
```bash
# App direktorioa eta fitxategiak
sudo chown -R backuser:backuser /home/backuser/app
sudo find /home/backuser/app -type d -exec chmod 755 {} \;   # Direktorioak
sudo find /home/backuser/app -type f -exec chmod 644 {} \;   # Fitxategiak

# Script exekutagarriak (adibidez, server.js, app.py)
sudo chmod 755 /home/backuser/app/server.js
```

### 4.3 Baimenak Egiaztatu

```bash
# Ikusi direktorio baten baimenak
ls -ld /home/frontuser/web
ls -ld /home/backuser/app

# Ikusi direktorio barneko fitxategien baimenak
ls -la /home/frontuser/web
ls -la /home/backuser/app

# Ikusi erabiltzaile baten taldeak
groups frontuser
groups backuser

# Ikusi nor den fitxategi baten jabea
stat /home/frontuser/web/index.html
```

---

## 5. FTP Zerbitzariaren Konfigurazio Zehatza

### 5.1 vsftpd Instalatu

```bash
# Instalatu vsftpd
sudo apt update
sudo apt install vsftpd -y

# Egiaztatu instalazioa
vsftpd -v
```

### 5.2 Konfigurazio Fitxategia

```bash
# Kopia segurtasun bat egin konfigurazio originaletik
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

# Editatu konfigurazioa
sudo nano /etc/vsftpd.conf
```

**Konfigurazio gomendatua:**

```conf
# ==========================================
# VSFTPD KONFIGURAZIO FITXATEGIA
# ==========================================

# Oinarrizko konfigurazioa
listen=YES
listen_ipv6=NO

# Anonimoak debekatu, erabiltzaile lokalak baimendu
anonymous_enable=NO
local_enable=YES

# Idazteko baimena eman
write_enable=YES
local_umask=022

# Mezu konfigurazioa
dirmessage_enable=YES
ftpd_banner=Ongi etorri FTP zerbitzarira

# Erabiltzaile lokalak jail-ean sartu (chroot)
chroot_local_user=YES
allow_writeable_chroot=YES

# Segurtasun direktorioa
secure_chroot_dir=/var/run/vsftpd/empty

# PAM autentikazioa
pam_service_name=vsftpd

# Ordu lokala erabili
use_localtime=YES

# Transferentzia log-a aktibatu
xferlog_enable=YES
xferlog_std_format=YES
xferlog_file=/var/log/vsftpd.log

# Port konfigurazioa
connect_from_port_20=YES

# Erabiltzaile zerrenda (whitelis)
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO

# Passive mode konfigurazioa
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40100
pasv_address=ZURE.IP.HELBIDEA  # Aldatu zure IP-ra

# Konexio limiteak
max_clients=50
max_per_ip=2

# Timeout-ak
idle_session_timeout=300
data_connection_timeout=120

# SSL/TLS (aukerakoa baina gomendatua)
# ssl_enable=YES
# rsa_cert_file=/etc/ssl/certs/vsftpd.pem
# rsa_private_key_file=/etc/ssl/private/vsftpd.key
# force_local_data_ssl=YES
# force_local_logins_ssl=YES
```

### 5.3 Erabiltzaile Zerrenda Sortu

```bash
# Sortu userlist fitxategia
sudo touch /etc/vsftpd.userlist

# Gehitu frontuser
echo "frontuser" | sudo tee /etc/vsftpd.userlist

# Egiaztatu
cat /etc/vsftpd.userlist
```

### 5.4 vsftpd Direktorioa Sortu

```bash
# Sortu secure_chroot_dir
sudo mkdir -p /var/run/vsftpd/empty
```

### 5.5 Berrabiarazi eta Gaitu

```bash
# Berrabiarazi zerbitzua
sudo systemctl restart vsftpd

# Gaitu hasieran
sudo systemctl enable vsftpd

# Egiaztatu egoera
sudo systemctl status vsftpd
```

### 5.6 Firewall Konfiguratu

```bash
# Ireki FTP portuak
sudo ufw allow 21/tcp
sudo ufw allow 40000:40100/tcp  # Passive mode portuak

# Berrikusi firewall egoera
sudo ufw status
```

---

## 6. SSH Konfigurazio Segurua

### 6.1 SSH Konfigurazio Fitxategia

```bash
# Kopia segurtasun bat egin
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Editatu konfigurazioa
sudo nano /etc/ssh/sshd_config
```

**Konfigurazio gomendatua:**

```conf
# ==========================================
# SSHD KONFIGURAZIO FITXATEGIA
# ==========================================

# Portua (aldatu aukerakoa, segurtasunerako)
Port 22
# Port 2222  # Port desberdin bat erabiltzeko

# Protokoloa
Protocol 2

# Entzuten duen helbidea
#ListenAddress 0.0.0.0
#ListenAddress ::

# HostKey-ak
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Logging
SyslogFacility AUTH
LogLevel INFO

# Autentikazioa
PermitRootLogin no                    # Root sarbidea debekatu
PubkeyAuthentication yes              # SSH key autentikazioa baimendu
PasswordAuthentication yes            # Pasahitz autentikazioa baimendu
PermitEmptyPasswords no               # Pasahitz hutsak debekatu
ChallengeResponseAuthentication no

# Erabiltzaile kontrola
# Soilik backuser eta admin erabiltzaileak baimendu
AllowUsers backuser admin

# frontuser debekatu (double-check)
DenyUsers frontuser

# GSSAPI options
GSSAPIAuthentication no
GSSAPICleanupCredentials yes

# X11 Forwarding
X11Forwarding yes
PrintMotd no

# TCP options
TCPKeepAlive yes
ClientAliveInterval 60
ClientAliveCountMax 3

# Subst options
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server

# Banner (aukerakoa)
#Banner /etc/ssh/ssh_banner.txt

# Saio hasiera saiakera limiteak
MaxAuthTries 3
MaxSessions 10

# Login grace time
LoginGraceTime 60
```

### 6.2 SSH Konfigurazioa Egiaztatu

```bash
# Egiaztatu sintaxia
sudo sshd -t

# Berrabiarazi SSH
sudo systemctl restart sshd

# Egiaztatu egoera
sudo systemctl status sshd
```

### 6.3 SSH Key Autentikazioa Konfiguratu (Gomendatua)

**Admin erabiltzailearentzat:**

```bash
# Zure ordenagailu lokalean (ez zerbitzarian!):
# Sortu SSH key parea (Windows-en Git Bash edo Linux/Mac-en terminal-ean)
ssh-keygen -t ed25519 -C "admin@zure-ordenagailua"

# Public key-a kopiatu zerbitzarira
ssh-copy-id admin@192.168.201.X

# Edo eskuz kopiatu:
cat ~/.ssh/id_ed25519.pub
# Kopiatu output-a

# Zerbitzarian:
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
# Itsatsi public key-a
chmod 600 ~/.ssh/authorized_keys

# Frogatu konexioa key bidez
ssh admin@192.168.201.X
```

**Aukerakoa: Pasahitz autentikazioa desgaitu** (SSH key bakarrik baimenduz):

```bash
sudo nano /etc/ssh/sshd_config

# Aldatu lerro hau:
PasswordAuthentication no

# Gorde, itxi eta berrabiarazi
sudo systemctl restart sshd
```

---

## 7. Frogak eta Egiaztapenak

### 7.1 frontuser Frogak

#### FTP Konexioa Frogatu

**Komando lerrotik (zerbitzarian):**
```bash
# Instalatu ftp client-a
sudo apt install ftp -y

# Frogatu konexioa
ftp localhost

# Sartu kredentzialak:
Name: frontuser
Password: [frontuser-en pasahitza]

# FTP komandoak:
ls              # Direktorio edukia ikusi
cd web          # web direktoriora joan
pwd             # Uneko direktorioa ikusi
mkdir test      # Test direktorioa sortu
rmdir test      # Test direktorioa ezabatu
put fitxategia  # Fitxategia igo
get fitxategia  # Fitxategia deskargatu
bye             # Irten
```

**FileZilla bidez (GUI):**
1. Ireki FileZilla
2. Host: `192.168.201.X`
3. Username: `frontuser`
4. Password: `frontuser-en pasahitza`
5. Port: `21`
6. Klik "Quickconnect"
7. Frogatu fitxategi bat igotzen

#### SSH Debekatua Egiaztatu

```bash
# Beste terminal batetik, frogatu SSH konexioa
ssh frontuser@localhost

# Emaitza esperatua:
# "Permission denied" edo "This account is currently not available"
```

**Proba log-a:**
```bash
# Ikusi auth log-a
sudo tail -f /var/log/auth.log

# SSH saiakera batekin ikusiko duzu:
# "User frontuser from X.X.X.X not allowed because listed in DenyUsers"
```

### 7.2 backuser Frogak

#### SSH Konexioa Frogatu

```bash
# Beste terminal batetik
ssh backuser@localhost

# Sartu pasahitza

# Egiaztatu erabiltzailea eta direktorioak
whoami
pwd
ls -la

# Git frogatu
git --version
git config --list

# Test repository clone
cd ~/app
git clone https://github.com/erabiltzailea/test-repo.git

# Irten
exit
```

#### FTP Debekatua Egiaztatu

```bash
# Frogatu FTP konexioa
ftp localhost

# Sartu kredentzialak:
Name: backuser
Password: [backuser-en pasahitza]

# Emaitza esperatua:
# "530 Login incorrect" edo "500 OOPS: cannot locate user entry:backuser"
```

### 7.3 Baimen Frogak

```bash
# frontuser direktorioetara sarbidea frogatu
sudo -u frontuser touch /home/frontuser/web/test.txt
sudo -u frontuser ls -l /home/frontuser/web/test.txt
sudo -u frontuser rm /home/frontuser/web/test.txt

# backuser direktorioetara sarbidea frogatu
sudo -u backuser touch /home/backuser/app/test.txt
sudo -u backuser ls -l /home/backuser/app/test.txt
sudo -u backuser rm /home/backuser/app/test.txt

# Egiaztatu erabiltzaile batek ezin duela bestearen direktorioan idatzi
sudo -u frontuser touch /home/backuser/app/test.txt
# Emaitza esperatua: "Permission denied"

sudo -u backuser touch /home/frontuser/web/test.txt
# Emaitza esperatua: "Permission denied"
```

### 7.4 Zerbitzuen Egoera Egiaztatu

```bash
# SSH egoera
sudo systemctl status sshd | grep "Active:"

# FTP egoera
sudo systemctl status vsftpd | grep "Active:"

# Portuen egiaztapena
sudo ss -tuln | grep -E ':22|:21'

# Log-ak aztertu
sudo tail -20 /var/log/auth.log       # SSH log-ak
sudo tail -20 /var/log/vsftpd.log     # FTP log-ak
```

### 7.5 Segurtasun Egiaztapenak

```bash
# Egiaztatu pasahitz politikak
sudo grep ^PASS_MAX_DAYS /etc/login.defs
sudo grep ^PASS_MIN_DAYS /etc/login.defs
sudo grep ^PASS_MIN_LEN /etc/login.defs

# Egiaztatu sudo erabiltzaileak
sudo grep -E '^sudo:' /etc/group

# Egiaztatu erabiltzaileak eta shell-ak
cat /etc/passwd | grep -E 'frontuser|backuser|admin'

# Azken saio hasierak ikusi
last -20
lastlog
```

---

## 8. Segurtasun Gomendioak

### 8.1 Pasahitzen Politika

```bash
# Instalatu libpam-pwquality
sudo apt install libpam-pwquality -y

# Editatu konfigurazioa
sudo nano /etc/security/pwquality.conf

# Gomendatutako parametroak:
minlen = 12              # Luzera minimoa
dcredit = -1             # Gutxienez digitu 1
ucredit = -1             # Gutxienez maiuskula 1
lcredit = -1             # Gutxienez minuskula 1
ocredit = -1             # Gutxienez karaktere berezi 1
```

### 8.2 Fail2ban Instalatu (Aukerakoa baina Gomendatua)

```bash
# Instalatu fail2ban
sudo apt install fail2ban -y

# Sortu konfigurazio lokala
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Editatu
sudo nano /etc/fail2ban/jail.local

# Gehitu edo aldatu:
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600

[vsftpd]
enabled = true
port = 21
filter = vsftpd
logpath = /var/log/vsftpd.log
maxretry = 3
bantime = 3600

# Berrabiarazi fail2ban
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

# Egiaztatu egoera
sudo fail2ban-client status
```

### 8.3 Erabiltzaile Auditoria

```bash
# Erabiltzaile zerrenda osoa ikusi
cat /etc/passwd

# Erabiltzaile normalak soilik (UID >= 1000)
awk -F: '$3 >= 1000 {print $1}' /etc/passwd

# Sudo baimenak dituzten erabiltzaileak
grep -E '^sudo:' /etc/group

# Shell-ak ikusi
cat /etc/passwd | grep -E 'bash|sh|nologin'

# Azken saio hasierak
last -20

# Erabiltzaile batek noiz aldatu zuen pasahitza
sudo chage -l erabiltzailea
```

---

## 9. Arazo Ohikoen Konponketa

### Arazo 1: frontuser-ek ezin du FTP bidez konektatu

**Konponketa:**
```bash
# Egiaztatu userlist-ean dagoela
cat /etc/vsftpd.userlist | grep frontuser

# Ez badago, gehitu
echo "frontuser" | sudo tee -a /etc/vsftpd.userlist

# Egiaztatu vsftpd konfigurazioa
sudo grep userlist /etc/vsftpd.conf

# Berrabiarazi vsftpd
sudo systemctl restart vsftpd

# Egiaztatu log-ak
sudo tail -f /var/log/vsftpd.log
```

### Arazo 2: backuser-ek ezin du SSH bidez konektatu

**Konponketa:**
```bash
# Egiaztatu sshd_config
sudo grep -E 'AllowUsers|DenyUsers' /etc/ssh/sshd_config

# Ziurtatu backuser AllowUsers-en dagoela
sudo nano /etc/ssh/sshd_config
# Gehitu edo aldatu: AllowUsers backuser admin

# Egiaztatu konfigurazioa
sudo sshd -t

# Berrabiarazi sshd
sudo systemctl restart sshd

# Egiaztatu log-ak
sudo tail -f /var/log/auth.log
```

### Arazo 3: "Permission denied" errorea direktorioa sartzerakoan

**Konponketa:**
```bash
# Egiaztatu jabetza
ls -ld /home/frontuser/web
ls -ld /home/backuser/app

# Zuzendu jabetza eta baimenak
sudo chown -R frontuser:frontuser /home/frontuser/web
sudo chmod -R 755 /home/frontuser/web

sudo chown -R backuser:backuser /home/backuser/app
sudo chmod -R 755 /home/backuser/app
```

---

## 10. Laburpen Checklist

### frontuser Konfigurazio Checklist

- [ ] Erabiltzailea sortuta: `sudo adduser frontuser`
- [ ] Pasahitza ezarrita (segurua)
- [ ] Web direktorioa sortuta: `/home/frontuser/web`
- [ ] Jabetza eta baimenak zuzenak
- [ ] SSH sarbidea debekatuta (`DenyUsers frontuser`)
- [ ] FTP sarbidea baimenduta (`/etc/vsftpd.userlist`-ean)
- [ ] FTP konexioa probatuta eta funtzionatzen du

### backuser Konfigurazio Checklist

- [ ] Erabiltzailea sortuta: `sudo adduser backuser`
- [ ] Pasahitza ezarrita (segurua)
- [ ] App direktorioa sortuta: `/home/backuser/app`
- [ ] Jabetza eta baimenak zuzenak
- [ ] SSH sarbidea baimenduta (`AllowUsers backuser`)
- [ ] SSH konexioa probatuta eta funtzionatzen du
- [ ] Git instalatuta eta konfiguratuta
- [ ] SSH key sortuta (aukerakoa)
- [ ] FTP sarbidea debekatuta (ez dago `/etc/vsftpd.userlist`-ean)

### Segurtasun Checklist

- [ ] Firewall konfiguratuta (UFW)
- [ ] SSH root sarbidea debekatuta
- [ ] Pasahitz politika konfiguratuta
- [ ] Fail2ban instalatuta (aukerakoa)
- [ ] Log-ak berrikusten dira erregularki
- [ ] Erabiltzaile baimenak egokiak dira

---

**Dokumentu Bertsioa:** 1.0
**Azken Eguneraketa:** 2025-01-19