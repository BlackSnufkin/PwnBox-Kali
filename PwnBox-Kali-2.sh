#!/bin/bash

fix_update () {

	
    eval apt -y update  && apt -y full-upgrade && apt -y autoremove    
    eval apt -y install dkms build-essential linux-headers-amd64 kali-root-login gufw golang docker-compose python3-venv gnome-terminal plank cargo docker.io tor lolcat xautomation guake starkiller open-vm-tools open-vm-tools-desktop fuse libssl-dev libffi-dev python-dev libpcap-dev python3-pip bettercap npm
    eval apt -y purge powershell-empire
 

}


if [ "$EUID" -ne 0 ]
    then echo  "[!] This Script must be run with sudo"
    exit
fi

apt -qq list kali-root-login | grep 'installed' &> /dev/null
if [ $? == 0 ]; then
	true;
else
    systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target;
    fix_update 
    apt update --fix-missing && apt full-upgrade -y && apt autoremove -y;
    echo -e "\n[+] Enabling Root Login Give root a password";
    passwd root;
    echo -e "[!] root login enabled \n";
    sleep 1; 
    
    finduser=$(logname)
    
    eval cp -Rvf  /home/$finduser/* /home/$finduser/.* /root >/dev/null 2>&1
    eval chown -R root:root /root
    raw_xfce="https://raw.githubusercontent.com/Dewalt-arch/pimpmyi3-config/main/xfce4/xfce4-power-manager.xml"
    eval wget $raw_xfce -O /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
    eval wget $raw_xfce -O /home/$finduser/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
    echo -e "[!] rebooring in 5 seconds";
    sleep 5;
    reboot;
	
	
fi

# Share Folder
shared_folder () {
	mkdir /root/HTB
	mkdir /root/OpenVPN
	mkdir /root/PT
	mkdir /opt/Tools
	mkdir /opt/Tools/C2
	mkdir /opt/Tools/Enumeration
	mkdir /opt/Tools/Mobile
	mkdir /opt/Tools/Payloads_gen
	mkdir /opt/Tools/Privilege-Escalation
	mkdir /opt/Tools/Web
	mkdir /opt/Tools/Wifi
	mkdir /opt/Tools/Active_Directory
	mkdir /opt/Tools/Network
	mkdir /opt/Tools/General
	cp  ./General/.zshrc /root/
	cp  ./General/.bashrc /root/ 
	mv ./replace.py /opt/Tools/General
	chmod +x /opt/Tools/General/replace.py
	ln -s /opt/Tools/General/replace.py /usr/bin/replace-line
	cp ./Wallpapers/wallpaper1.jpg /usr/share/backgrounds
	cp -R ./Wallpapers/* /root/Pictures/
	cp /root/Pictures/loginscreen.jpg /usr/share/desktop-base/kali-theme/login
	mv /usr/share/desktop-base/kali-theme/login/background /usr/share/desktop-base/kali-theme/login/background.original
	mv /usr/share/desktop-base/kali-theme/login/loginscreen.jpg /usr/share/desktop-base/kali-theme/login/background
	xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorVirtual1/workspace0/last-image --set /root/Pictures/wallpaper1.jpg

	}

pwnbox (){
	# Pwnbox	
	echo -e "\n [+] Installing Pwnbox Stuff"
	mkdir /opt/Customize-Kali && mkdir /opt/Customize-Kali/gitclones 
	git -C /opt/Customize-Kali/gitclones/ clone https://github.com/theGuildHall/pwnbox.git
	cp ./General/banner /opt/Customize-Kali/gitclones/pwnbox/
  cp  ./General/banner.sh /opt/Customize-Kali/gitclones/pwnbox/ 
	cd /opt/Customize-Kali/gitclones/pwnbox
	cp -R bloodhound/ /opt/Tools/Enumeration && cp -R htb/ /opt/Customize-Kali && cp -R icons/ /opt/Customize-Kali/htb && cp banner /opt/Customize-Kali/htb && cp *.sh /opt/Customize-Kali/htb
	apt install -y powershell
	mkdir ~/.config/powershell/
	cp /opt/Customize-Kali/gitclones/pwnbox/Microsoft.PowerShell_profile.ps1 $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1
	cp /opt/Customize-Kali/gitclones/pwnbox/htb.jpg /usr/share/backgrounds/
	cp -R /opt/Customize-Kali/gitclones/pwnbox/Material-Black-Lime-Numix-FLAT/ /usr/share/icons/
	cp -R /opt/Customize-Kali/gitclones/pwnbox/htb /usr/share/icons/
	mkdir /usr/share/themes/HackTheBox && cp /opt/Customize-Kali/gitclones/pwnbox/index.theme /usr/share/themes/HackTheBox
	xfconf-query -c xsettings -p /Net/IconThemeName -s Material-Black-Lime-Numix-FLAT
	xfconf-query -c xfwm4 -p /general/show_dock_shadow -s false
    
    }

utils () {

	# pycharm install
	# at the end create Desktop entry
	echo '[+] Download Pycharm-community'
	cd /root/Downloads
	wget  https://download.jetbrains.com/python/pycharm-community-2021.2.1.tar.gz
	tar xvzf ~/Downloads/pycharm-community*.tar.gz -C /tmp/
	chown -R root:root /tmp/pycharm*
	mv /tmp/pycharm-community* /opt/pycharm-community
	ln -s /opt/pycharm-community/bin/pycharm.sh /usr/local/bin/pycharm
	ln -s /opt/pycharm-community/bin/inspect.sh /usr/local/bin/inspect
	rm -r pycharm-community-2020.2.2.tar.gz

	#Sublime
	echo '[+] Download sublimetext 3'
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
	apt-get install apt-transport-https
	bash -c 'echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list'
	apt-get update
	apt-get install sublime-text

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
	
	# Obsidian
	cd /tmp
	wget "https://github.com/obsidianmd/obsidian-releases/releases/download/v0.12.15/Obsidian-0.12.15.AppImage" -O obsidian
    chmod +x obsidian
    mv obsidian /usr/bin/obsidian
	
	}


tools () {
	# Tools
	# Web Tools
	echo -e "\n [+] Installing Web-Tools"
	cd /opt/Tools/Web
	# Dirsearc
	echo -e "\n [+] Installing Dirsearch"
	git clone https://github.com/maurosoria/dirsearch.git
	# magicRecon
	echo -e "\n [+] Installing magicRecon"
	git clone https://github.com/robotshell/magicRecon.git
	#fuff
	echo -e "\n [+] Installing fuff"
	git clone https://github.com/ffuf/ffuf ; cd ffuf ; go get ; go build
	
	#OneListForAll
	cd /opt/Tools/General
	git clone https://github.com/nil0x42/duplicut
	cd duplicut/ && make
	cp duplicut /usr/bin
	cd /opt/Tools/Web
	echo -e "\n [+] Installing OneListForAll"
	git clone https://github.com/six2dez/OneListForAll.git
	cd OneListForAll
	./olfa.sh
	cd /opt/Tools/Web
	
#Wifi Tools
	echo -e "\n [+] Installing Wifi-Tools"
	cd /opt/Tools/Wifi
	echo -e "\n [+] Installing OWT"
	git clone https://github.com/clu3bot/OWT.git
	echo -e "\n [+] Installing websploit"
	git clone https://github.com/websploit/websploit.git
	echo -e "\n [+] Installing airgeddon"
	git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git


#Mobile Tools
	# Mobsf
	echo -e "\n [+] Installing Mobile-Tools"
	cd /opt/Tools/Mobile
	echo -e "\n [+] Installing Mobsf"
	git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
	cd Mobile-Security-Framework-MobSF
	docker build -t mobsf . 
	echo 'docker run -it --rm -p 8000:8000 mobsf' >> /usr/bin/mobsf-start
	chmod +x /usr/bin/mobsf-start
	
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



# C&C
	echo -e "\n [+] Installing C2-Tools"
	# Evil-winrm
	cd /opt/Tools/C2
	echo -e "\n [+] Installing Evil-winrm"
	git clone --branch dev https://github.com/Hackplayers/evil-winrm.git
	cd evil-winrm
	bundle install
	gem install rubyntlm

	# dnscat
	cd /opt/Tools/C2
	echo -e "\n [+] Installing dnscat2"
	git clone https://github.com/iagox86/dnscat2.git
	cd dnscat2/server/
	bundle install

	# Pwncat
	cd /opt/Tools/C2
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
	echo -e "\n [+] Installing Empire & deathstar"
	pip install poetry
	git clone --recursive https://github.com/BC-SECURITY/Empire.git
	cd Empire
	./setup/install.sh
	poetry install
	poetry run python empire
	python3 -m pip install pipx
	source $HOME/.profile
	pipx install deathstar-empire
	


#Enumeartion-Tools
	# Rustscan
	echo -e "\n [+] Installing Enumeration-Tools"
	cd /opt/Tools/Enumeration
	echo -e "\n [+] Installing Rustscan"
	git clone https://github.com/RustScan/RustScan.git
	cd RustScan
	cargo build --release
	echo 'command = ["-sC","-sV","-O","-Pn"]' >> ~/.rustscan.toml
	echo 'batch_size = 65535' >> ~/.rustscan.toml
	echo 'timeout = 3500' >> ~/.rustscan.toml
	echo 'ulimit = 7000' >> ~/.rustscan.toml

	# Enum4linux-ng
	cd /opt/Tools/Enumeration
	echo -e "\n [+] Installing Enum4linux-ng"
	git clone https://github.com/cddmp/enum4linux-ng.git
	#dnsrecon
	git clone https://github.com/darkoperator/dnsrecon.git

	# Nmap Vuln scan
	rm -r /usr/share/nmap/scripts
    echo -e "[+] /usr/share/nmap/scripts removed "
   	cd /tmp
   	git clone https://github.com/nmap/nmap.git
   	mv nmap/scripts /usr/share/nmap/
   	rm -rf nmap 
    eval wget https://raw.githubusercontent.com/onomastus/pentest-tools/master/fixed-http-shellshock.nse -O /usr/share/nmap/scripts/http-shellshock.nse 
    echo -e "\n[+] /usr/share/nmap/script as updated"
	cd /usr/share/nmap/scripts
	echo -e "\n [+] Installing nmap-vulners, vulscan"
	git clone https://github.com/vulnersCom/nmap-vulners.git
	git clone https://github.com/scipag/vulscan.git
	cd vulscan/utilities/updater/
	chmod +x updateFiles.sh
	./updateFiles.sh
	
	cd /opt/Tools/
	git clone https://github.com/s4n7h0/NSE.git
	cd NSE
	cp *.nse /usr/share/nmap/scripts
	
	cd /opt/Tools/
	git clone https://github.com/psc4re/NSE-scripts.git
	cd NSE-scripts
	cp *.nse /usr/share/nmap/scripts
	cd /opt/
	
	rm -rf /opt/Tools/NSE-scripts
	rm -rf /opt/Tools/NSE
	nmap --script-updatedb

	# Nmap Visulize Network
	cd /opt/Tools/Enumeration
	git clone https://github.com/tedsluis/nmap.git
	mv nmap Nmap_Network-visualization                 
	cd Nmap_Network-visualization
	wget https://gojs.net/latest/release/go.js
	
	

	# Bloodhound
	cd /opt/Tools/Enumeration
	mkdir /opt/Tools/Enumeration/BloodHound
	cd /opt/Tools/Enumeration/BloodHound
	echo -e "\n [+] Installing Bloodhound & BloodHound Utils"
	git clone https://github.com/BloodHoundAD/AzureHound.git
	git clone https://github.com/fox-it/BloodHound.py.git
    cd BloodHound.py 
    pip3 install .
    
    cd /opt/Tools/Enumeration/BloodHound
	mkdir /opt/Tools/Enumeration/BloodHound/BloodHound-Util
	cd /opt/Tools/Enumeration/BloodHound/BloodHound-Util
	git clone https://github.com/kaluche/bloodhound-quickwin.git
	pip3 install py2neo
	pip3 install pandas
	pip3 install prettytable
	git clone https://github.com/seajaysec/cypheroth.git
	
	cd /opt/Tools/Enumeration/BloodHound
	git clone https://github.com/BloodHoundAD/BloodHound.git
	wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
	echo 'deb https://debian.neo4j.com stable 4.0' | sudo tee /etc/apt/sources.list.d/neo4j.list
	apt update
	apt install neo4j=1:4.0.8 -y
	cd BloodHound
	wget https://github.com/BloodHoundAD/BloodHound/releases/download/4.0.3/BloodHound-linux-arm64.zip
	unzip BloodHound-linux-arm64.zip
	rm BloodHound-linux-arm64.zip
	echo 'exec /opt/Tools/Enumeration/BloodHound/BloodHound-linux-x64/BloodHound --no-sandbox' > /usr/bin/bloodhound
	chmod +x /usr/bin/bloodhound


# Networking Tools
	cd /opt/Tools/Network
	echo -e "\n [+] Installing Network-Tools"
	git clone https://github.com/lgandx/PCredz.git
	pip3 install Cython && pip3 install python-libpcap
	git clone https://github.com/fox-it/mitm6.git
	
	
# Tunneling-Tools
	# Proxychains
	mkdir /opt/Tools/Tunneling 
	cd /opt/Tools/Tunneling 
	apt purge proxychains4 -y && apt purge proxychains
	git clone https://github.com/rofl0r/proxychains-ng.git
	cd proxychains-ng
	./configure --prefix=/usr --sysconfdir=/etc
  	make
  	make install-config
  	ln -s $PWD/proxychains4 /usr/bin/proxychains
  	replace-line "socks5 127.0.0.1 1080" 159 /etc/proxychains.conf
  	echo "# sock4 127.0.0.1 9050" >> /etc/proxychains.conf
  	cd /opt/Tools/Tunneling 
  	wget https://github.com/jpillora/chisel/releases/download/v1.7.6/chisel_1.7.6_windows_amd64.gz
  	gunzip chisel_1.7.6_windows_amd64.gz
  	mv chisel* chisel.exe

	# Ptunnel-ng
	cd /opt/Tools/Tunneling 
	git clone https://github.com/lnslbrty/ptunnel-ng.git
	cd ptunnel-ng
	./autogen.sh
 
	# chisel
	curl https://i.jpillora.com/chisel! | bash
	mv /usr/local/bin/chisel /usr/bin/chisel


# Privilege-Escalation-Tools
	# LuckyCheck
	cd /opt/Tools/Privilege-Escalation
	echo -e "\n [+] Installing LuckyCheck"
	git clone https://github.com/BlackSnufkin/LuckyCheck.git


# Active Directory Tools
	# impcaket
	echo -e "\n [+] Installing Active Directory"
	cd /opt/Tools/Active_Directory
	echo -e "\n [+] Installing impacket"
	git clone https://github.com/SecureAuthCorp/impacket.git
	cd impacket
	python3 -m venv impacket-env 
	source impacket-env/bin/activate
	python3 setup.py install
	deactivate

	# Zerologon
	cd /opt/Tools/Active_Directory
	mkdir Zerologon
	echo -e "\n [+] Installing Zerologon"
	cd Zerologon
	git clone https://github.com/Privia-Security/ADZero.git
	git clone https://github.com/dirkjanm/CVE-2020-1472.git
	wget "https://raw.githubusercontent.com/SecuraBV/CVE-2020-1472/master/zerologon_tester.py" -O zerologon_tester.py

	#PrintNightmare
	cd /opt/Tools/Active_Directory
	mkdir PrintNightmare
	echo -e "\n [+] Installing PrintNightmare"
	cd PrintNightmare
	python3 -m venv PrintNightmare-env
	source PrintNightmare-env/bin/activate
	
	git clone https://github.com/cube0x0/CVE-2021-1675.git
	cd CVE-2021-1675
	curl https://raw.githubusercontent.com/SleepiPanda/CVE-2021-1675/bce1f74677c653ea8fc4babf96b7a55ec8f77be2/threaded_CVE-2021-1675.py -o threaded_CVE-2021-1675.py 
	cd ..
	git clone https://github.com/cube0x0/impacket
	cd impacket
	python3 ./setup.py install
	deactivate
	cd ..
	git clone https://github.com/byt3bl33d3r/ItWasAllADream
	cd ItWasAllADream && poetry install
	touch start-env.sh
	echo -e '#!/bin/zsh \npoetry shell' > start-env.sh;chmod +x start-env.sh

	#PetitPotam
	cd /opt/Tools/Active_Directory
	git clone https://github.com/topotam/PetitPotam.git


	
	

# Payload Generetor
	# ysoserial
	cd /opt/Tools/Payloads_gen
	echo -e "\n [+] Installing ysoserial"
	git clone https://github.com/frohoff/ysoserial
	# Invoke-Stealth
	echo -e "\n [+] Installing Invoke-Stealth"
	git clone https://github.com/JoelGMSec/Invoke-Stealth.git



	# Stabilize Shell
	cd /opt/Tools/General
	echo -e "\n [+] Installing poor-mans-pentest"
	git clone https://github.com/JohnHammond/poor-mans-pentest.git
	cd poor-mans-pentest
	replace-line '    xte "key F12"' 15 functions.sh
	replace-line 'call_cmd "/usr/bin/script -qc /bin/bash /dev/null"' 6 stabilize_zsh_shell.sh
	replace-line 'source "/opt/Tools/General/poor-mans-pentest/functions.sh"' 3 stabilize_zsh_shell.sh
	echo 'call_cmd "exec clear"' >> stabilize_zsh_shell.sh
	ln -s /opt/Tools/General/poor-mans-pentest/stabilize_zsh_shell.sh /usr/bin/stabilize_shell

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
      echo -e "\n   python-pip installed"
    else
      echo -e "\n   python-pip already installed"
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
    echo -e "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
    apt update && apt full-upgrade -y && apt autoremove -y && reboot

	}

touch ~/.hushlogin
systemctl enable docker
systemctl enable openvpn
updatedb
msfdb init 
shared_folder
pwnbox
utils
tools
fix_stuff
