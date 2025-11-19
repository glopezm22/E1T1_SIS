# Komando Erresumaen Cheat Sheet

## 📋 Aurkibidea

1. [Sistema Informazioa](#sistema-informazioa)
2. [Erabiltzaile Kudeaketa](#erabiltzaile-kudeaketa)
3. [Fitxategi eta Direktorio Kudeaketa](#fitxategi-eta-direktorio-kudeaketa)
4. [Baimenen Kudeaketa](#baimenen-kudeaketa)
5. [Sare Konfigurazioa](#sare-konfigurazioa)
6. [Sare Diagnostikoa](#sare-diagnostikoa)
7. [Zerbitzu Kudeaketa](#zerbitzu-kudeaketa)
8. [Prozesu Kudeaketa](#prozesu-kudeaketa)
9. [Pakete Kudeaketa](#pakete-kudeaketa)
10. [Log Analisia](#log-analisia)
11. [Backup eta Konprimazioa](#backup-eta-konprimazioa)
12. [Firewall (UFW)](#firewall-ufw)
13. [SSH Konfigurazioa](#ssh-konfigurazioa)
14. [FTP Konfigurazioa](#ftp-konfigurazioa)
15. [Git Komandoak](#git-komandoak)

---

## 1. Sistema Informazioa

```bash
# Sistema informazio orokorra
uname -a                    # Kernel informazioa
hostnamectl                 # Hostname eta sistema informazioa
lsb_release -a              # Distribuzio informazioa

# Hardware informazioa
lscpu                       # CPU informazioa
lsmem                       # Memoria informazioa
lsblk                       # Bloke gailu informazioa
lspci                       # PCI gailu informazioa
lsusb                       # USB gailu informazioa

# Uptime eta karga
uptime                      # Sistema uptime eta load average
w                           # Nor dago konektatuta eta zer egiten ari da
who                         # Nor dago konektatuta

# Data eta ordua
date                        # Egungo data eta ordua
timedatectl                 # Data/ordu konfigurazioa ikusi

# Disko informazioa
df -h                       # Partizioen erabilera (human-readable)
df -i                       # Inodo erabilera
du -sh /path/to/dir         # Direktorio baten tamaina
du -h --max-depth=1         # Azpidirektorioen tamainak

# Memoria informazioa
free -h                     # Memoria erabilera (human-readable)
cat /proc/meminfo           # Memoria xehetasun guztiak
vmstat                      # Memoria, I/O, CPU estatistikak

# CPU informazioa
cat /proc/cpuinfo           # CPU xehetasun guztiak
mpstat                      # CPU estatistikak (sysstat paketea)
```

---

## 2. Erabiltzaile Kudeaketa

```bash
# Erabiltzaileak sortu eta ezabatu
sudo adduser erabiltzailea          # Erabiltzaile berria sortu (interaktiboa)
sudo useradd erabiltzailea          # Erabiltzaile berria sortu (ez-interaktiboa)
sudo userdel erabiltzailea          # Erabiltzailea ezabatu
sudo userdel -r erabiltzailea       # Erabiltzailea eta home direktorioa ezabatu

# Pasahitza kudeaketa
sudo passwd erabiltzailea           # Erabiltzaile baten pasahitza aldatu
passwd                              # Nire pasahitza aldatu
sudo passwd -l erabiltzailea        # Erabiltzaile bat blokeatu
sudo passwd -u erabiltzailea        # Erabiltzaile bat desblokeatu
sudo chage -l erabiltzailea         # Pasahitz iraungitze informazioa
sudo chage -M 90 erabiltzailea      # Pasahitza 90 egunero iraungitzea

# Talde kudeaketa
sudo groupadd taldea                # Talde berria sortu
sudo groupdel taldea                # Taldea ezabatu
sudo usermod -aG taldea erabiltzailea  # Erabiltzailea talde batera gehitu
groups erabiltzailea                # Erabiltzaile baten taldeak ikusi
sudo gpasswd -d erabiltzailea taldea   # Erabiltzailea taldetik kendu

# Erabiltzaile propietateak aldatu
sudo usermod -s /bin/bash erabiltzailea    # Shell-a aldatu
sudo usermod -d /home/berria erabiltzailea # Home direktorioa aldatu
sudo usermod -l izen_berria izen_zaharra   # Erabiltzaile izena aldatu
sudo usermod -aG sudo erabiltzailea        # Sudo baimenak eman

# Informazioa ikusi
id                                  # Nire UID, GID eta taldeak
id erabiltzailea                    # Erabiltzaile baten UID, GID eta taldeak
whoami                              # Nor naiz
cat /etc/passwd                     # Erabiltzaile guztiak
cat /etc/group                      # Talde guztiak
last                                # Azken saio hasierak
lastlog                             # Azken saio hasiera erabiltzaileka
```

---

## 3. Fitxategi eta Direktorio Kudeaketa

```bash
# Nabigazioa
pwd                         # Uneko direktorioa
cd /path/to/dir             # Direktoriora joan
cd ..                       # Goiko direktoriora joan
cd ~                        # Home direktoriora joan
cd -                        # Aurreko direktoriora itzuli

# Zerrendak
ls                          # Fitxategiak zerrendatu
ls -l                       # Zerrenda luzea (baimenak, tamaina...)
ls -la                      # Ezkutuko fitxategiak ere barne
ls -lh                      # Tamaina human-readable formatuan
ls -lt                      # Dataren arabera ordenatu
ls -lS                      # Tamainaren arabera ordenatu
tree                        # Zuhaitz-ikuspegia

# Sortu eta ezabatu
mkdir direktorioa           # Direktorio berria sortu
mkdir -p /path/to/dir       # Direktorio hierarkia sortu
touch fitxategia            # Fitxategi hutsa sortu
rm fitxategia               # Fitxategia ezabatu
rm -r direktorioa           # Direktorioa eta edukia ezabatu
rm -rf direktorioa          # Indarrez ezabatu (kontuz!)
rmdir direktorioa           # Direktorio hutsa ezabatu

# Kopiatu eta mugitu
cp iturria helmuga          # Fitxategia kopiatu
cp -r iturria helmuga       # Direktorioa kopiatu
mv iturria helmuga          # Fitxategia/direktorioa mugitu edo izena aldatu
rsync -av iturria helmuga   # Sinkronizatu (gomendatua)

# Fitxategi edukia
cat fitxategia              # Fitxategia erakutsi
less fitxategia             # Fitxategia orrialdeka ikusi
head fitxategia             # Lehenengo 10 lerroak
head -n 20 fitxategia       # Lehenengo 20 lerroak
tail fitxategia             # Azken 10 lerroak
tail -n 20 fitxategia       # Azken 20 lerroak
tail -f fitxategia          # Fitxategiari jarraitu (realtime)

# Bilatu
find /path -name "*.txt"    # Fitxategi bat bilatu izenaren arabera
find /path -type d          # Direktorioak soilik
find /path -type f          # Fitxategiak soilik
find /path -mtime -7        # 7 egun barruan aldatutakoak
find /path -size +100M      # 100MB baino handiagoak
grep "testua" fitxategia    # Testua fitxategi batean bilatu
grep -r "testua" /path      # Testua direktorio batean bilatu (rekurtsiboa)
grep -i "testua" fitxategia # Bilaketa ez-sentiblea (case-insensitive)
locate fitxategia           # Fitxategia azkar bilatu (updatedb behar)

# Estekak
ln iturria esteka           # Hard link sortu
ln -s iturria esteka        # Symbolic link sortu
readlink esteka             # Estekaren helburua ikusi

# Konparatu
diff fitxategi1 fitxategi2  # Bi fitxategiak konparatu
comm fitxategi1 fitxategi2  # Bi fitxategi ordenatuen lerroak konparatu
cmp fitxategi1 fitxategi2   # Bi fitxategi binarioak konparatu
```

---

## 4. Baimenen Kudeaketa

```bash
# Baimenak ikusi
ls -l fitxategia            # Fitxategi baten baimenak ikusi
stat fitxategia             # Fitxategi informazio osoa

# Baimenak aldatu (chmod)
chmod 755 fitxategia        # rwxr-xr-x
chmod 644 fitxategia        # rw-r--r--
chmod +x script.sh          # Exekuzio baimena gehitu
chmod -x script.sh          # Exekuzio baimena kendu
chmod u+w fitxategia        # Jabeak idazketa baimena gehitu
chmod g-w fitxategia        # Taldeak idazketa baimena kendu
chmod o-r fitxategia        # Besteak irakurketa baimena kendu
chmod -R 755 direktorioa    # Rekurtsiboki baimenak aldatu

# Jabetza aldatu (chown)
sudo chown erabiltzailea fitxategia           # Jabea aldatu
sudo chown erabiltzailea:taldea fitxategia   # Jabea eta taldea aldatu
sudo chown -R erabiltzailea direktorioa      # Rekurtsiboki jabea aldatu
sudo chgrp taldea fitxategia                 # Taldea aldatu

# Baimenen kodeak
# r (read)    = 4
# w (write)   = 2
# x (execute) = 1
#
# Adibideak:
# 777 = rwxrwxrwx = 4+2+1, 4+2+1, 4+2+1
# 755 = rwxr-xr-x = 4+2+1, 4+0+1, 4+0+1
# 644 = rw-r--r-- = 4+2+0, 4+0+0, 4+0+0
# 600 = rw------- = 4+2+0, 0+0+0, 0+0+0

# Baimenen laburpenak
# u = user (jabea)
# g = group (taldea)
# o = others (besteak)
# a = all (guztiak)
#
# + = gehitu baimena
# - = kendu baimena
# = = ezarri baimenak (besteak ezabatuz)

# Umask (fitxategi berriak sortzean baimen lehenetsiak)
umask                       # Uneko umask ikusi
umask 022                   # Umask ezarri (644 fitxategientzat, 755 direktorioentzat)
umask 077                   # Umask zorrotza (600 fitxategientzat, 700 direktorioentzat)
```

---

## 5. Sare Konfigurazioa

```bash
# Interfaze informazioa
ip addr show                        # IP konfigurazioa ikusi
ip addr show ens18                  # Interfaze jakin baten IP konfigurazioa
ip link show                        # Sare interfaze guztiak
ifconfig                            # IP konfigurazioa (zaharkitua baina oraindik erabilia)

# IP konfigurazioa aldatu (aldi baterako)
sudo ip addr add 192.168.1.100/24 dev ens18    # IP bat gehitu
sudo ip addr del 192.168.1.100/24 dev ens18    # IP bat kendu
sudo ip link set ens18 up                      # Interfazea aktibatu
sudo ip link set ens18 down                    # Interfazea desaktibatu

# Routing
ip route show                       # Routing taula ikusi
ip route get 8.8.8.8               # Nola iristen den IP batera
sudo ip route add default via 192.168.1.1     # Gateway lehenetsiko bat gehitu
sudo ip route del default via 192.168.1.1     # Gateway lehenetsiko bat kendu

# DNS konfigurazioa
cat /etc/resolv.conf                # DNS zerbitzariak ikusi
resolvectl status                   # DNS egoera ikusi (systemd-resolved)
nslookup google.com                 # DNS ebazpena frogatu
dig google.com                      # DNS ebazpen xehatua
host google.com                     # DNS ebazpen sinplea

# Netplan (Ubuntu 18.04+)
sudo netplan apply                  # Netplan konfigurazioa aplikatu
sudo netplan try                    # Netplan konfigurazioa frogatu (120s timeout)
sudo netplan generate               # Netplan konfigurazioa sortu

# Network Manager
nmcli device status                 # Gailu egoera
nmcli connection show               # Konexio guztiak
nmcli connection up IZENA           # Konexioa aktibatu
nmcli connection down IZENA         # Konexioa desaktibatu

# Sare zerbitzua berrabiarazi
sudo systemctl restart networking           # Debian/Ubuntu zaharra
sudo systemctl restart NetworkManager       # Network Manager
sudo netplan apply                          # Netplan

# MAC helbidea
ip link show                        # MAC helbideak ikusi
sudo ip link set dev ens18 address XX:XX:XX:XX:XX:XX  # MAC aldatu
```

---

## 6. Sare Diagnostikoa

```bash
# Ping - Konexioa frogatu
ping -c 4 8.8.8.8                   # 4 pakete bidali
ping -c 10 -i 0.5 192.168.1.1       # 10 pakete 0.5s tartez
ping -f 192.168.1.1                 # Flood ping (root)

# Traceroute - Bidea aztertu
traceroute google.com               # Bidea ikusi
traceroute -n google.com            # Bidea ikusi (DNS ebazpenik gabe)
mtr google.com                      # Traceroute hobetua

# Konexio aktiboak
ss -tuln                            # TCP eta UDP entzuten dauden portuak
ss -tan                             # TCP konexio guztiak
ss -tun                             # UDP konexio guztiak
ss -tan | grep ESTAB                # TCP konexio ezarritakoak
ss -tan | grep :80                  # 80 portuko konexioak
netstat -tuln                       # ss-ren alternatiba (zaharkitua)

# Portu eskaneaketa
nmap localhost                      # Lokal portuen eskaneaketa
nmap 192.168.1.1                    # Urrutiko portuen eskaneaketa
nmap -p 1-65535 192.168.1.1         # Portu guztiak eskaneatu
nmap -sV 192.168.1.1                # Zerbitzu bertsioak detektatu
nmap 192.168.1.0/24                 # Sare osoko eskaneaketa

# Trafiko analisia
sudo tcpdump -i ens18               # Trafikoa ikusi interfaze batean
sudo tcpdump -i ens18 port 80       # 80 portuko trafikoa
sudo tcpdump -i ens18 host 192.168.1.1  # Host jakin batetik trafikoa
sudo tcpdump -i ens18 -w capture.pcap   # Trafikoa fitxategian gorde
sudo tcpdump -r capture.pcap        # Captura bat irakurri
iftop                               # Sare trafikoa realtime-an ikusi

# ARP taula
ip neigh show                       # ARP taula ikusi
arp -a                              # ARP taula ikusi (zaharkitua)
sudo ip neigh flush all             # ARP cache-a garbitu

# Bandwidth testa
iperf3 -s                           # Zerbitzari moduan hasi
iperf3 -c IP_ZERBITZARIA            # Bezero moduan konektatu
iperf3 -c IP_ZERBITZARIA -u -b 100M # UDP proba 100Mbps-rekin

# Sare estatistikak
ifstat                              # Interfaze estatistikak
netstat -s                          # Sare estatistika orokorrak
ip -s link                          # Interfaze estatistikak (paketeak, erroreak)

# Telnet - Portua frogatu
telnet 192.168.1.1 80               # Portu bat ireki den egiaztatu
nc -zv 192.168.1.1 80               # Netcat-ekin portu bat egiaztatu

# curl - HTTP eskaera bat egin
curl http://google.com              # Web orri bat deskargatu
curl -I http://google.com           # Goiburu HTTP-ak soilik
curl -v http://google.com           # Verbose moduan
curl -o fitxategia http://url       # URL bat fitxategian gorde

# wget - Fitxategiak deskargatu
wget http://url/fitxategia          # Fitxategi bat deskargatu
wget -c http://url/fitxategia       # Deskarga jarraitu
wget -r http://url/                 # Web oso bat deskargatu
wget --spider http://url            # Soilik egiaztatu existitzen den
```

---

## 7. Zerbitzu Kudeaketa

```bash
# Systemctl - Zerbitzuen kudeaketa
sudo systemctl start ZERBITZUA      # Zerbitzua hasi
sudo systemctl stop ZERBITZUA       # Zerbitzua gelditu
sudo systemctl restart ZERBITZUA    # Zerbitzua berrabiarazi
sudo systemctl reload ZERBITZUA     # Konfigurazioa birkargatu
sudo systemctl status ZERBITZUA     # Egoera ikusi
sudo systemctl enable ZERBITZUA     # Hasieran abiaraztean gaitu
sudo systemctl disable ZERBITZUA    # Hasieran abiaraztean desgaitu
sudo systemctl is-active ZERBITZUA  # Aktibo dagoen egiaztatu
sudo systemctl is-enabled ZERBITZUA # Gaituta dagoen egiaztatu

# Zerbitzu zerrenda
systemctl list-units --type=service                 # Zerbitzu guztiak
systemctl list-units --type=service --state=running # Zerbitzu martxan daudenak
systemctl list-units --type=service --state=failed  # Zerbitzu huts egin dutenak
systemctl list-unit-files --type=service            # Zerbitzu fitxategi guztiak

# Systemd log-ak
sudo journalctl -u ZERBITZUA        # Zerbitzu baten log-ak
sudo journalctl -u ZERBITZUA -f     # Log-ak realtime-an jarraitu
sudo journalctl -u ZERBITZUA -n 50  # Azken 50 lerroak
sudo journalctl --since "2025-01-01"  # Data jakin batetik
sudo journalctl --since "1 hour ago"  # Azken orduko log-ak
sudo journalctl -p err              # Soilik erroreak
sudo journalctl --disk-usage        # Log-ek hartzen duten espazioa
sudo journalctl --vacuum-time=7d    # 7 egun baino zaharragoak ezabatu

# Systemctl komando gehigarriak
systemctl daemon-reload             # Systemd konfigurazioa birkargatu
systemctl get-default               # Target lehenetsia ikusi
systemctl set-default multi-user.target  # Target lehenetsia ezarri
systemctl isolate multi-user.target      # Target batera aldatu
systemctl poweroff                  # Sistema itzali
systemctl reboot                    # Sistema berrabiarazi
systemctl suspend                   # Sistema eseki
systemctl hibernate                 # Hibernate
```

---

## 8. Prozesu Kudeaketa

```bash
# Prozesuen zerrenda
ps                          # Uneko shell-eko prozesuen zerrenda
ps aux                      # Prozesu guztien zerrenda xehatua
ps -ef                      # Prozesu guztien zerrenda formatu desberdinean
pstree                      # Prozesu zuhaitza ikusi
pgrep IZENA                 # Prozesu bat bilatu izenaren arabera

# Prozesu informazioa
top                         # Prozesu dinamikoen zerrenda
htop                        # top-en bertsioa hobetua (instalatu behar da)
pidof PROGRAMA              # Programa baten PID-a lortu

# Prozesu ordenatu
ps aux --sort=-%cpu         # CPU erabileraren arabera
ps aux --sort=-%mem         # Memoria erabileraren arabera
ps aux --sort=-rss          # RSS memoria erabileraren arabera

# Prozesu bat hil
kill PID                    # Prozesu bat hil (TERM seinale)
kill -9 PID                 # Prozesu bat indarrez hil (KILL seinale)
killall PROGRAMA            # Programa bat hil (prozesu guztiak)
pkill IZENA                 # Prozesu bat hil izenaren arabera

# Seinale desberdinak
kill -l                     # Seinale guztien zerrenda
kill -TERM PID              # TERM seinale bidali (15, lehenetsia)
kill -KILL PID              # KILL seinale bidali (9, indarrez)
kill -HUP PID               # HUP seinale bidali (1, birkargatu)
kill -USR1 PID              # USR1 seinale bidali (10)

# Lehentasuna aldatu
nice -n 10 KOMANDOA         # Lehentasun baxuagoarekin exekutatu (+10)
renice -5 -p PID            # Prozesu baten lehentasuna aldatu
sudo renice -10 -p PID      # Lehentasun altuagoa ezarri (root)

# Background eta foreground
KOMANDOA &                  # Komandoa background-ean exekutatu
jobs                        # Background lan zerrenda
fg %1                       # Lan bat foreground-era ekarri
bg %1                       # Lan bat background-ean jarraitu
Ctrl+Z                      # Prozesu bat geldiarazi
Ctrl+C                      # Prozesu bat amaitu

# nohup - Prozesu bat saioan itxi ondoren jarraitzeko
nohup KOMANDOA &            # Komandoa nohup-ekin exekutatu
nohup KOMANDOA > output.log 2>&1 &  # Output log batean gorde

# screen / tmux - Sesioak kudeatu
screen                      # Screen sesio berria hasi
screen -S izena             # Screen sesio bat izen jakin batekin
screen -ls                  # Screen sesioen zerrenda
screen -r                   # Screen sesio bat berreskuratu
screen -r izena             # Screen sesio jakin bat berreskuratu
Ctrl+A D                    # Screen sesio batetik deskonektatu

tmux                        # tmux sesio berria hasi
tmux ls                     # tmux sesioen zerrenda
tmux attach                 # tmux sesio bat berreskuratu
tmux attach -t izena        # tmux sesio jakin bat berreskuratu
Ctrl+B D                    # tmux sesio batetik deskonektatu
```

---

## 9. Pakete Kudeaketa

```bash
# APT (Debian/Ubuntu)
sudo apt update                     # Pakete zerrenda eguneratu
sudo apt upgrade                    # Pakete guztiak eguneratu
sudo apt dist-upgrade               # Distro eguneraketa
sudo apt install PAKETEA            # Paketea instalatu
sudo apt remove PAKETEA             # Paketea desinstalatu
sudo apt purge PAKETEA              # Paketea eta konfigurazioak desinstalatu
sudo apt autoremove                 # Erabiltzen ez diren dependentziak ezabatu
sudo apt clean                      # Cache-a garbitu
apt search PAKETEA                  # Paketea bilatu
apt show PAKETEA                    # Pakete informazioa ikusi
apt list --installed                # Instalatutako paketeak zerrendatu
apt list --upgradable               # Eguneragarriak diren paketeak

# dpkg (Debian paketeak)
sudo dpkg -i paketea.deb            # .deb paketea instalatu
sudo dpkg -r PAKETEA                # Paketea desinstalatu
sudo dpkg -l                        # Instalatutako pakete zerrenda
dpkg -L PAKETEA                     # Pakete baten fitxategiak ikusi
dpkg -S /path/to/file               # Zein paketek fitxategi bat duen

# Snap (Ubuntu)
snap find PAKETEA                   # Snap paketea bilatu
sudo snap install PAKETEA           # Snap paketea instalatu
sudo snap remove PAKETEA            # Snap paketea desinstalatu
snap list                           # Instalatutako snap paketeak
sudo snap refresh                   # Snap pakete guztiak eguneratu
sudo snap refresh PAKETEA           # Snap pakete jakin bat eguneratu

# Flatpak
flatpak search PAKETEA              # Flatpak paketea bilatu
flatpak install PAKETEA             # Flatpak paketea instalatu
flatpak uninstall PAKETEA           # Flatpak paketea desinstalatu
flatpak list                        # Instalatutako flatpak paketeak
flatpak update                      # Flatpak pakete guztiak eguneratu
```

---

## 10. Log Analisia

```bash
# Sistemaren log-ak
sudo tail -f /var/log/syslog        # Sistema log-ak jarraitu
sudo tail -f /var/log/auth.log      # Autentikazio log-ak jarraitu
sudo tail -f /var/log/kern.log      # Kernel log-ak jarraitu
sudo tail -n 100 /var/log/syslog    # Azken 100 lerroak

# journalctl (systemd log-ak)
sudo journalctl                     # Log guztiak
sudo journalctl -f                  # Log-ak jarraitu realtime-an
sudo journalctl -n 100              # Azken 100 lerroak
sudo journalctl -p err              # Soilik erroreak
sudo journalctl -p warning          # Warning-ak eta gorako erroreak
sudo journalctl --since "2025-01-01"  # Data jakin batetik
sudo journalctl --since "1 hour ago"  # Azken orduko log-ak
sudo journalctl --since "yesterday"   # Atzotik
sudo journalctl -u ZERBITZUA        # Zerbitzu jakin baten log-ak
sudo journalctl -k                  # Kernel log-ak soilik
sudo journalctl --disk-usage        # Log-en disko erabilera
sudo journalctl --vacuum-time=7d    # 7 egun baino zaharragoak ezabatu
sudo journalctl --vacuum-size=1G    # 1GB-ra murriztu log-ak

# dmesg - Kernel ring buffer
dmesg                               # Kernel mezuak
dmesg | tail                        # Azken kernel mezuak
dmesg | grep -i error               # Kernel erroreak
dmesg -T                            # Timestamp-ekin
dmesg -w                            # Kernel mezuak jarraitu

# Zerbitzu zehatzen log-ak
sudo tail -f /var/log/apache2/access.log    # Apache access log
sudo tail -f /var/log/apache2/error.log     # Apache error log
sudo tail -f /var/log/nginx/access.log      # Nginx access log
sudo tail -f /var/log/nginx/error.log       # Nginx error log
sudo tail -f /var/log/vsftpd.log            # vsftpd log
sudo tail -f /var/log/mysql/error.log       # MySQL error log

# Log analisi tresnak
grep "ERROR" /var/log/syslog        # ERROR testua bilatu
grep -i "failed" /var/log/auth.log  # "failed" bilatu (case-insensitive)
grep -E "error|warning" /var/log/syslog  # ERROR edo WARNING
awk '/ERROR/ {print $0}' /var/log/syslog  # AWK-ekin filtratu
sed -n '/ERROR/p' /var/log/syslog   # SED-ekin filtratu
```

---

## 11. Backup eta Konprimazioa

```bash
# tar - Artxibatzea
tar -czf backup.tar.gz /path/to/dir     # Direktorioa konprimitu (.tar.gz)
tar -xzf backup.tar.gz                  # .tar.gz deskonprimitu
tar -xzf backup.tar.gz -C /path/        # Direktorio jakin batera deskonprimitu
tar -tzf backup.tar.gz                  # .tar.gz edukia ikusi
tar -cjf backup.tar.bz2 /path/to/dir    # bzip2-ekin konprimitu (.tar.bz2)
tar -xjf backup.tar.bz2                 # .tar.bz2 deskonprimitu
tar -cJf backup.tar.xz /path/to/dir     # xz-ekin konprimitu (.tar.xz)
tar -xJf backup.tar.xz                  # .tar.xz deskonprimitu

# gzip - Konprimazioa
gzip fitxategia                     # Fitxategia konprimitu (.gz)
gzip -d fitxategia.gz               # .gz deskonprimitu
gunzip fitxategia.gz                # .gz deskonprimitu
gzip -k fitxategia                  # Konprimitu originala mantenduz
gzip -9 fitxategia                  # Konprimatze maximo

# zip / unzip
zip backup.zip fitxategia           # ZIP bat sortu
zip -r backup.zip direktorioa       # Direktorioa ZIP-era konprimitu
unzip backup.zip                    # ZIP bat deskonprimitu
unzip -l backup.zip                 # ZIP edukia ikusi
unzip backup.zip -d /path/          # Direktorio jakin batera deskonprimitu

# rsync - Sinkronizazioa
rsync -av iturria/ helmuga/         # Direktorioa sinkronizatu
rsync -av --delete iturria/ helmuga/  # Sinkronizatu eta ezabatu sobrakoak
rsync -avz iturria/ user@host:/path/  # Urrutiko zerbitzarira sinkronizatu
rsync -av --progress iturria/ helmuga/  # Progresioa erakutsi
rsync -av --exclude='*.log' iturria/ helmuga/  # .log fitxategiak baztertu

# dd - Disko irudiak
sudo dd if=/dev/sda of=backup.img bs=4M status=progress  # Diskoa irudi batera kopiatu
sudo dd if=backup.img of=/dev/sda bs=4M status=progress  # Irudia diskora idatzi
```

---

## 12. Firewall (UFW)

```bash
# UFW oinarrizkoa
sudo ufw status                     # Firewall egoera
sudo ufw status verbose             # Firewall egoera xehatua
sudo ufw enable                     # Firewall gaitu
sudo ufw disable                    # Firewall desgaitu
sudo ufw reload                     # Firewall birkargatu
sudo ufw reset                      # Firewall berrezarri (guztia ezabatu)

# Arauak gehitu
sudo ufw allow 22                   # 22 portua baimendu
sudo ufw allow 22/tcp               # 22 portua TCP-an baimendu
sudo ufw allow ssh                  # SSH baimendu (22 portua)
sudo ufw allow http                 # HTTP baimendu (80 portua)
sudo ufw allow https                # HTTPS baimendu (443 portua)
sudo ufw allow 1000:2000/tcp        # Portu tartea baimendu
sudo ufw allow from 192.168.1.100   # IP jakin bat baimendu
sudo ufw allow from 192.168.1.0/24  # Sare oso bat baimendu

# Arauak ezabatu
sudo ufw delete allow 22            # 22 portua blokeatu
sudo ufw status numbered            # Arauak zenbakiarekin ikusi
sudo ufw delete 2                   # 2. araua ezabatu

# Arau aurreratuak
sudo ufw allow from 192.168.1.100 to any port 22    # IP batek portu jakin batera
sudo ufw deny from 10.0.0.0/8                       # Sare bat blokeatu
sudo ufw limit ssh                                  # SSH rate limiting (brute-force)

# Politika lehenetsiak
sudo ufw default deny incoming      # Sarrera guztiak blokeatu (lehenetsia)
sudo ufw default allow outgoing     # Irteera guztiak baimendu (lehenetsia)

# Log-ak
sudo ufw logging on                 # Firewall log-ak aktibatu
sudo ufw logging off                # Firewall log-ak desaktibatu
sudo tail -f /var/log/ufw.log       # UFW log-ak ikusi
```

---

## 13. SSH Konfigurazioa

```bash
# SSH konexioak
ssh erabiltzailea@IP                # SSH bidez konektatu
ssh -p 2222 erabiltzailea@IP        # Port desberdin bat erabiliz
ssh -i ~/.ssh/key erabiltzailea@IP  # Key jakin bat erabiliz
ssh -v erabiltzailea@IP             # Verbose moduan (debugging)
ssh -L 8080:localhost:80 user@IP    # Local port forwarding
ssh -R 8080:localhost:80 user@IP    # Remote port forwarding
ssh -D 1080 erabiltzailea@IP        # Dynamic port forwarding (SOCKS proxy)

# SSH key-ak
ssh-keygen                          # SSH key parea sortu
ssh-keygen -t ed25519               # ed25519 key parea sortu (gomendatua)
ssh-keygen -t rsa -b 4096           # RSA 4096 bit key parea sortu
ssh-keygen -t ed25519 -C "komentarioa"  # Komentarioarekin
ssh-copy-id erabiltzailea@IP        # Public key zerbitzarira kopiatu
ssh-add ~/.ssh/id_ed25519           # Private key ssh-agent-era gehitu
ssh-add -l                          # ssh-agent-eko key-en zerrenda
ssh-add -D                          # ssh-agent-eko key guztiak ezabatu

# SSH konfigurazioa
nano ~/.ssh/config                  # SSH konfigurazio fitxategia editatu
# Adibidea:
# Host zerbitzaria
#     HostName 192.168.1.100
#     User admin
#     Port 22
#     IdentityFile ~/.ssh/id_ed25519

# SSH zerbitzaria konfiguratu
sudo nano /etc/ssh/sshd_config      # sshd konfigurazioa editatu
sudo sshd -t                        # Konfigurazioa egiaztatu
sudo systemctl restart sshd         # sshd berrabiarazi

# SCP - Fitxategiak kopiatu SSH bidez
scp fitxategia user@IP:/path/       # Fitxategia zerbitzarira kopiatu
scp user@IP:/path/fitxategia ./     # Fitxategia zerbitzaritik kopiatu
scp -r direktorioa user@IP:/path/   # Direktorioa zerbitzarira kopiatu
scp -P 2222 fitxategia user@IP:/path/  # Port desberdin bat erabiliz

# SFTP - FTP segurua SSH bidez
sftp erabiltzailea@IP               # SFTP konexioa hasi
sftp -P 2222 erabiltzailea@IP       # Port desberdin bat erabiliz
# SFTP komandoak:
# ls, cd, pwd, mkdir, rmdir, get, put, mget, mput, bye
```

---

## 14. FTP Konfigurazioa

```bash
# FTP Client (komando lerroa)
ftp IP_HELBIDEA                     # FTP konexioa hasi
ftp                                 # FTP client-a hasi
# FTP komandoak:
# open IP                           # Zerbitzarira konektatu
# user ERABILTZAILEA                # Erabiltzailea sartu
# ls                                # Direktorio edukia zerrendatu
# cd DIREKTORIOA                    # Direktoriora joan
# pwd                               # Uneko direktorioa
# mkdir DIREKTORIOA                 # Direktorioa sortu
# rmdir DIREKTORIOA                 # Direktorioa ezabatu
# get FITXATEGIA                    # Fitxategia deskargatu
# put FITXATEGIA                    # Fitxategia igo
# mget *.txt                        # Fitxategi anitz deskargatu
# mput *.txt                        # Fitxategi anitz igo
# delete FITXATEGIA                 # Fitxategia ezabatu
# binary                            # Modu binariora aldatu
# ascii                             # Modu ASCII-ra aldatu
# passive                           # Passive modua aktibatu/desaktibatu
# bye edo quit                      # Irten

# lftp (FTP client hobetua)
lftp ftp://user@IP                  # lftp konexioa hasi
lftp -u user,password ftp://IP      # Kredentzialak zuzenean
# lftp komandoak:
# mirror /remote/dir /local/dir     # Direktorioa sinkronizatu
# mirror -R /local/dir /remote/dir  # Reverse mirror (igo)
# pget -n 4 FITXATEGIA              # 4 konexiorekin deskargatu
# mget *.txt                        # Fitxategi anitz deskargatu
# bye                               # Irten

# vsftpd zerbitzaria konfiguratu
sudo apt install vsftpd             # vsftpd instalatu
sudo nano /etc/vsftpd.conf          # Konfigurazioa editatu
sudo systemctl restart vsftpd       # vsftpd berrabiarazi
sudo systemctl status vsftpd        # Egoera egiaztatu

# vsftpd log-ak
sudo tail -f /var/log/vsftpd.log    # vsftpd log-ak jarraitu

# Erabiltzaile zerrenda
sudo nano /etc/vsftpd.userlist      # Userlist editatu
```

---

## 15. Git Komandoak

```bash
# Git konfigurazioa
git config --global user.name "Zure Izena"          # Izena konfiguratu
git config --global user.email "email@example.com"  # Email-a konfiguratu
git config --list                                   # Konfigurazioa ikusi
git config --global core.editor nano                # Editor lehenetsia

# Repository-ak sortu
git init                            # Repository lokal berria sortu
git clone URL                       # Repository bat klonatu
git clone URL DIREKTORIOA           # Direktorio jakin batera klonatu
git clone git@github.com:user/repo.git  # SSH bidez klonatu

# Aldaketak kudeatu
git status                          # Egoera ikusi
git add FITXATEGIA                  # Fitxategia staging area-ra gehitu
git add .                           # Fitxategi guztiak gehitu
git add -A                          # Fitxategi guztiak gehitu (ezabatzeak barne)
git reset FITXATEGIA                # Fitxategia staging area-tik kendu
git diff                            # Aldaketak ikusi (unstaged)
git diff --staged                   # Aldaketak ikusi (staged)

# Commit-ak
git commit -m "Mezua"               # Commit bat sortu
git commit -am "Mezua"              # Add eta commit batera
git commit --amend                  # Azken commit-a aldatu
git log                             # Commit historia ikusi
git log --oneline                   # Historia laburtua
git log --graph --oneline --all     # Historia grafikotan

# Branch-ak
git branch                          # Branch zerrenda ikusi
git branch IZENA                    # Branch berria sortu
git checkout IZENA                  # Branch batera aldatu
git checkout -b IZENA               # Branch berria sortu eta aldatu
git branch -d IZENA                 # Branch bat ezabatu
git branch -D IZENA                 # Branch bat indarrez ezabatu
git merge IZENA                     # Branch bat unekoan batu

# Remote repository-ak
git remote                          # Remote-en zerrenda
git remote -v                       # Remote-en zerrenda URL-ekin
git remote add origin URL           # Remote bat gehitu
git remote remove origin            # Remote bat ezabatu
git fetch origin                    # Remote-tik aldaketak deskargatu
git pull origin BRANCH              # Pull egin (fetch + merge)
git push origin BRANCH              # Push egin
git push -u origin BRANCH           # Push egin eta upstream ezarri
git push --all                      # Branch guztiak push

# Aldaketak desegin
git reset --soft HEAD~1             # Azken commit-a desegin (aldaketak mantenduz)
git reset --hard HEAD~1             # Azken commit-a desegin (aldaketak ezabatuz)
git reset --hard origin/main        # Remote-ko egoerara itzuli
git revert COMMIT_ID                # Commit bat desegin commit berri batekin
git clean -fd                       # Fitxategi untracked-ak ezabatu

# Stash - Aldaketak aldi baterako gorde
git stash                           # Aldaketak gorde
git stash list                      # Stash zerrenda
git stash apply                     # Azken stash-a aplikatu
git stash pop                       # Azken stash-a aplikatu eta ezabatu
git stash drop                      # Azken stash-a ezabatu
git stash clear                     # Stash guztiak ezabatu

# Tag-ak
git tag                             # Tag zerrenda
git tag v1.0.0                      # Tag bat sortu
git tag -a v1.0.0 -m "Mezua"        # Tag anotatu bat sortu
git push origin v1.0.0              # Tag bat push
git push --tags                     # Tag guztiak push

# Git informazioa
git show COMMIT_ID                  # Commit bat ikusi
git blame FITXATEGIA                # Nor aldatu zuen fitxategi bakoitza
git reflog                          # Eginiko ekintza guztien historia
```

---

## 📝 Ohar Garrantzitsuak

### Baimen Kodeak
```
r (read)    = 4
w (write)   = 2
x (execute) = 1

Adibideak:
755 = rwxr-xr-x = 4+2+1, 4+0+1, 4+0+1
644 = rw-r--r-- = 4+2+0, 4+0+0, 4+0+0
600 = rw------- = 4+2+0, 0+0+0, 0+0+0
```

### Sinboloak
```
>   Output zuzendu (gainidatzi)
>>  Output zuzendu (gehitu)
<   Input zuzendu
|   Pipe (komando baten output-a bestea input gisa)
&   Background-ean exekutatu
&&  Eta (bigarrena exekutatu lehena ondo amaitu bada)
||  Edo (bigarrena exekutatu lehena huts egin badu)
;   Komandoen sekuentzia
```

### Laster-teklak
```
Ctrl+C  - Uneko prozesua amaitu
Ctrl+Z  - Uneko prozesua geldiarazi
Ctrl+D  - EOF (End of File) bidali edo sesioa itxi
Ctrl+L  - Pantaila garbitu (edo: clear)
Ctrl+A  - Lerroaren hasierara joan
Ctrl+E  - Lerroaren amaierara joan
Ctrl+U  - Kurtsorearen ezkerreko guztia ezabatu
Ctrl+K  - Kurtsorearen eskuineko guztia ezabatu
Ctrl+R  - Historia bilatu (reverse search)
Tab     - Auto-osatu
!!      - Azken komandoa errepikatu
!$      - Azken komandoaren azken argumentua
sudo !! - Azken komandoa sudo-ekin errepikatu
```

---

**Dokumentu Bertsioa:** 1.0  
**Azken Eguneraketa:** 2025-01-19