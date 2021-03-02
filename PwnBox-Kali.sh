#!/bin/bash

fix_update () {

	
	eval apt -y update  && apt -y full-upgrade && apt -y autoremove    
    eval apt -y install dkms build-essential linux-headers-amd64 kali-root-login python3-venv gnome-terminal plank cargo docker.io tor lolcat xautomation guake open-vm-tools open-vm-tools-desktop fuse libssl-dev libffi-dev python-dev

}


if [ "$EUID" -ne 0 ]
    then echo  "[!] This Script must be run with sudo"
    exit
fi

apt -qq list kali-root-login | grep 'installed' &> /dev/null
if [ $?  == 0 ]; then
	true;
else
	systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target;
   	fix_update 
    apt update --fix-missing && apt full-upgrade -y && apt autoremove -y;
    echo -e "\n[+] Enabling Root Login Give root a password";
    passwd root;
    echo -e "[!] root login enabled \n";
    sleep 1;
    UN=$USER 
    eval cp -Rvf /home/$UN/.* /home/$UN/* /root >/dev/null 2>&1
    eval chown -R root:root /root

	
	
fi

# Share Folder
shared_folder () {

	mkdir /root/HTB
	mkdir /root/OpenVPN

	mkdir /opt/Tools
	mkdir /opt/Tools/BruteForce
	mkdir /opt/Tools/C2
	mkdir /opt/Tools/Enumeration
	mkdir /opt/Tools/Mobile
	mkdir /opt/Tools/Payloads_gen
	mkdir /opt/Tools/Privilege-Escalation
	mkdir /opt/Tools/Web
	mkdir /opt/Tools/Active_Directory
	mkdir /opt/Tools/General

	cp  ./General/.zshrc /root/
	cp  ./General/.bashrc /root/ 
	
	cp ./Wallpapers/wallpaper1.jpg /usr/share/backgrounds

	cp -R ./Wallpapers/* /root/Pictures/
	cd /usr/share/desktop-base/kali-theme/login/
	cp root/Pictures/loginscreen.jpg /usr/share/desktop-base/kali-theme/login
	mv background background.original
	mv loginscreen.jpg background
	
	mv replace.py /opt/Tools/General
	ln -s /opt/Tools/General/replace.py /usr/bin/replace-line
	xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorVirtual1/workspace0/last-image --set /root/Pictures/wallpaper1.jpg

	}


# pycharm install
# at the end create Desktop entry
pycharm () {

	echo '[+] Download Pycharm-community'
	cd /root/Downloads
	wget  https://download.jetbrains.com/python/pycharm-community-2020.2.2.tar.gz
	tar xvzf ~/Downloads/pycharm-community*.tar.gz -C /tmp/
	chown -R root:root /tmp/pycharm*
	mv /tmp/pycharm-community* /opt/pycharm-community
	ln -s /opt/pycharm-community/bin/pycharm.sh /usr/local/bin/pycharm
	ln -s /opt/pycharm-community/bin/inspect.sh /usr/local/bin/inspect
	rm -r pycharm-community-2020.2.2.tar.gz

	}


#Sublime
#Set free version
sublimetext () {

	echo '[+] Download sublimetext 3'
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
	apt-get install apt-transport-https
	bash -c 'echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list'
	apt-get update
	apt-get install sublime-text

	}
     

tools () {
# Tools

# Dirsearc
	echo -e "\n [+] Installing dirsearch"
	cd /opt/Tools/Web
	git clone https://github.com/maurosoria/dirsearch.git

# Mobsf
	cd /opt/Tools/Mobile
	echo -e "\n [+] Installing Mobsf"
	git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
	cd Mobile-Security-Framework-MobSF
	docker build -t mobsf . 
	echo 'docker run -it --rm -p 8000:8000 mobsf' >> /usr/bin/mobsf-start
	chmod +x /usr/bin/mobsf

# Phonesploit
	cd /opt/Tools/Mobile
	echo -e "\n [+] Installing Phonesploit"
	git clone https://github.com/01010000-kumar/PhoneSploit
	cd PhoneSploit
	pip3 install colorama

# SSL pining
	cd /opt/Tools/Mobile
	echo -e "\n [+] Installing AndroidPinning"
	git clone https://github.com/moxie0/AndroidPinning.git

# Evil-winrm
	cd /opt/Tools/C2
	echo -e "\n [+] Installing Evil-winrm"
	git clone https://github.com/Hackplayers/evil-winrm.git
	cd evil-winrm
	bundle install

# dnscat
	cd /opt/Tools/C2
	echo -e "\n [+] Installing dnscat2"
	git clone https://github.com/iagox86/dnscat2.git
	cd dnscat2/server/
	gem install bundler
	bundle install

# Pwncat
	cd /opt/Tools/C2/
	echo -e "\n [+] Installing Pwncat"
	git clone https://github.com/calebstewart/pwncat.git
	cd pwncat
	python3 -m venv pwncat-env
	source pwncat-env/bin/activate
	python setup.py install
	pip install -r requirements.txt
	ln -s $PWD/pwncat-env/bin/pwncat /usr/bin/ 
	deactivate

# Empire
	cd /opt/Tools/C2
	echo -e "\n [+] Installing Empire"
	git clone https://github.com/BC-SECURITY/Empire.git
	cd Empire
	./setup/install.sh
	ln -s $PWD/empire /usr/bin

# Rustscan
	cd /opt/Tools/Enumeration
	echo -e "\n [+] Installing Rustscan"
	git clone https://github.com/RustScan/RustScan.git
	cd RustScan
	cargo build --release
	echo 'command = ["-sC","-sV","-O"]' >> ~/.rustscan.toml
	echo 'batch_size = 65535' >> ~/.rustscan.toml
	echo 'timeout = 3500' >> ~/.rustscan.toml
	echo 'ulimit = 7000' >> ~/.rustscan.toml


# Bloodhound
	cd /opt/Tools/Enumeration
	echo -e "\n [+] Installing Bloodhound"
	git clone https://github.com/BloodHoundAD/BloodHound.git
	wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
	echo 'deb https://debian.neo4j.com stable 4.0' | sudo tee /etc/apt/sources.list.d/neo4j.list
	apt update
	apt install neo4j=1:4.0.8 -y
	cd BloodHound
	wget https://github.com/BloodHoundAD/BloodHound/releases/download/4.0.2/BloodHound-linux-x64.zip
	unzip BloodHound-linux-x64.zip
	rm BloodHound-linux-x64.zip
	echo 'exec /opt/Tools/Enumeration/BloodHound/BloodHound-linux-x64/BloodHound --no-sandbox' > /usr/bin/bloodhound
	chmod +x /usr/bin/bloodhound

# Enum4linux-ng
	cd /opt/Tools/Enumeration
	echo -e "\n [+] Installing Enum4linux-ng"
	git clone https://github.com/cddmp/enum4linux-ng.git

# LuckyCheck
	cd /opt/Tools/Privilege-Escalation
	echo -e "\n [+] Installing LuckyCheck"
	git clone https://github.com/BlackSnufkin/LuckyCheck.git

# Nmap Vuln scan
	rm -r /usr/share/nmap/scripts
    echo -e "[+] /usr/share/nmap/scripts removed "
   	cd /tmp
   	git clone https://github.com/nmap/nmap.git
   	mv nmap/scripts /usr/share/nmap/
   	rm -r nmap 
    eval wget https://raw.githubusercontent.com/onomastus/pentest-tools/master/fixed-http-shellshock.nse -O /usr/share/nmap/scripts/http-shellshock.nse 
    echo -e "\n[+] /usr/share/nmap/script as updated"
	cd /usr/share/nmap/scripts/
	echo -e "\n [+] Installing nmap-vulners, vulscan"
	git clone https://github.com/vulnersCom/nmap-vulners.git
	git clone https://github.com/scipag/vulscan.git
	cd vulscan/utilities/updater/
	chmod +x updateFiles.sh
	./updateFiles
	nmap --script-updatedb

# impcaket
	cd /opt/Tools/Active_Directory
	echo -e "\n [+] Installing impacket"
	git clone https://github.com/SecureAuthCorp/impacket.git
	cd impacket
	python3 -m venv impacket-env 
	source impacket-env/bin/activate
	python setup.py install
	deactivate

# Zerologon
	cd /opt/Tools/Active_Directory
	mkdir Zerologon
	echo -e "\n [+] Installing Zerologon"
	cd Zerologon
	git clone https://github.com/Privia-Security/ADZero.git
	git clone https://github.com/dirkjanm/CVE-2020-1472.git

# ysoserial
	cd /opt/Tools/Payloads_gen
	echo -e "\n [+] Installing ysoserial"
	git clone https://github.com/frohoff/ysoserial

# Stabilize Shell
	cd /opt/Tools/General
	echo -e "\n [+] Installing poor-mans-pentest"
	git clone https://github.com/JohnHammond/poor-mans-pentest.git
	cd poor-mans-pentest
	replace-line '    xte "key F12"' 15 functions.sh
	replace-line 'call_cmd "/usr/bin/script -qc /bin/bash /dev/null"' 6 stabilize_zsh_shell.sh
	replace-line 'source "/opt/Tools/poor-mans-pentest/functions.sh"' 3 stabilize_zsh_shell.sh
	echo 'call_cmd "exec clear"' >> stabilize_zsh_shell.sh
	ln -s /opt/Tools/poor-mans-pentest/stabilize_zsh_shell.sh /usr/bin/stabilize_shell

# bat
	cd ~
	echo -e "\n [+] Installing bat"
	cargo install --locked bat
	ln -s /root/.cargo/bin/bat /usr/bin/bat
	bat --generate-config-file
	echo '--pager="cat"' >  /root/.config/bat/config 

	#Rockyou
	cd /usr/share/wordlists
    gzip -dq /usr/share/wordlists/rockyou.txt.gz

	}


chrome () {
# Chorme 

	cd /root/Downloads
	echo -e "\n [+] Installing Chrome"
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	dpkg -i ./google-chrome*.deb
	apt-get install -f -y
	rm google-chrome-stable_current_amd64.deb
	replace-line 'deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main' 3 /etc/apt/sources.list.d/google-chrome.list  
	replace-line '# exec -a "$0" "$HERE/chrome" "$@" --user-data-dir --test-type --no-sandbox' 49 /opt/google/chrome/google-chrome 
	echo 'exec -a "$0" "$HERE/chrome" "$@" --no-sandbox' >> /opt/google/chrome/google-chrome
	
	}


pwnbox (){
# Pwnbox
	
	echo -e "\n [+] Installing Pwnbox Stuff"
	mkdir /opt/PwnBox-Kali && mkdir /opt/PwnBox-Kali/gitclones 
	cd /opt/PwnBox-Kali/gitclones
	git clone https://github.com/theGuildHall/pwnbox.git
	cd /opt/PwnBox-Kali/gitclones/pwnbox
	cp -R bloodhound/ /opt/Tools/Enumeration && cp -R htb/ /opt/PwnBox-Kali && cp -R icons/ /opt/PwnBox-Kali/htb && cp banner /opt/PwnBox-Kali/htb && cp *.sh /opt/PwnBox-Kali/htb
	apt install -y powershell
	mkdir ~/.config/powershell/
	cp /opt/PwnBox-Kali/gitclones/pwnbox/Microsoft.PowerShell_profile.ps1 ~/.config/powershell/Microsoft.PowerShell_profile.ps1
	cp /opt/PwnBox-Kali/gitclones/pwnbox/htb.jpg /usr/share/backgrounds/
	cp -R /opt/PwnBox-Kali/gitclones/pwnbox/Material-Black-Lime-Numix-FLAT/ /usr/share/icons/
	cp -R /opt/PwnBox-Kali/gitclones/pwnbox/htb /usr/share/icons/
	mkdir /usr/share/themes/HackTheBox && cp /opt/PwnBox-Kali/gitclones/pwnbox/index.theme /usr/share/themes/HackTheBox
	xfconf-query -c xsettings -p /Net/IconThemeName -s Material-Black-Lime-Numix-FLAT
	xfconf-query -c xfwm4 -p /general/show_dock_shadow -s false
   	cp  ./General/banner /opt/PwnBox-Kali/htb
    cp  ./General/banner.sh /opt/PwnBox-Kali/htb
    
    }



fix_stuff () {

	echo -e "\n [+] Fixing Pip For python 2.7 "
	check_pip=$(pip --version | grep -i -c "/usr/local/lib/python2.7/dist-packages/pip")
    if [ $check_pip -ne 1 ]
     then
      echo -e "\n  $greenplus installing pip"
      # 01.26.2021 - get-pip.py throwing an error, commented out and pointed wget directly to the python2.7 get-pip.py
      # eval curl curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py $silent
      eval curl https://raw.githubusercontent.com/pypa/get-pip/3843bff3a0a61da5b63ea0b7d34794c5c51a2f11/2.7/get-pip.py -o /tmp/get-pip.py $silent
      eval python /tmp/get-pip.py $silent
      rm -f /tmp/get-pip.py
      eval pip install setuptools
      echo -e "\n  $greenplus python-pip installed"
    else
      echo -e "\n  $greenminus python-pip already installed"
    fi
	
    check_min=$(cat /etc/samba/smb.conf | grep -c -i "client min protocol")
    check_max=$(cat /etc/samba/smb.conf | grep -c -i "client max protocol")
    if [ $check_min -ne 0 ] || [ $check_max -ne 0 ]
      then
        echo -e "\n [+] /etc/samba/smb.conf "
        echo -e "\n[+] client min protocol is already set not changing\n   client max protocol is already set not changing"
      else
        cat /etc/samba/smb.conf | sed 's/\[global\]/\[global\]\n   client min protocol = CORE\n   client max protocol = SMB3\n''/' > /tmp/fix_smbconf.tmp
        cat /tmp/fix_smbconf.tmp > /etc/samba/smb.conf
        rm -f /tmp/fix_smbconf.tmp
        echo -e "\n[+] /etc/samba/smb.conf updated"
        echo -e "\n [+] added : client min protocol = CORE\n  $greenplus added : client max protocol = SMB3"
    
    fi


    sed -i 's/.*AutomaticLoginEnable =.*/AutomaticLoginEnable = true/' /etc/gdm3/daemon.conf
	sed -i 's/.*AutomaticLogin =.*/AutomaticLogin = root/' /etc/gdm3/daemon.conf
    apt update && apt full-upgrade -y && apt autoremove -y && reboot



	}


systemctl enable docker
systemctl enable openvpn
updatedb
msfdb init 
shared_folder
pwnbox
pycharm
sublimetext
chrome
tools
fix_stuff
