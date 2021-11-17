#!/bin/bash

# status indicators
greenplus='\e[1;33m[++]\e[0m'
greenminus='\e[1;33m[--]\e[0m'
redminus='\e[1;31m[--]\e[0m'
redexclaim='\e[1;31m[!!]\e[0m'
redstar='\e[1;31m[**]\e[0m'
blinkexclaim='\e[1;31m[\e[5;31m!!\e[0m\e[1;31m]\e[0m'
fourblinkexclaim='\e[1;31m[\e[5;31m!!!!\e[0m\e[1;31m]\e[0m'


Fix_hushlogin() {
    finduser=$(logname)
    echo -e "\n  $greenplus Checking for .hushlogin"
    if [ $finduser = "root" ]
     then
      if [ -f /root/.hushlogin ]
       then
        echo -e "\n  $greenminus /$finduser/.hushlogin exists - skipping"
      else
        echo -e "\n   $greenplus Creating file /$finduser/.hushlogin"
        touch /$finduser/.hughlogin
      fi
    else
      if [ -f /home/$finduser/.hushlogin ]
       then
        echo -e "\n  $greenminus /home/$finduser/.hushlogin exists - skipping"
      else
        echo -e "\n  $greenplus Creating file /home/$finduser/.hushlogin"
        touch /home/$finduser/.hushlogin
      fi
    fi
}


disable_power_gnome() {

    greenplus='\e[1;33m[++]\e[0m'
    finduser=$(logname)
    Fix_hushlogin
    # CODE CONTRIBUTION : pswalia2u - https://github.com/pswalia2u
    echo -e "\n  $greenplus Gnome detected - Disabling Power Savings"
    # ac power
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing      # Disables automatic suspend on charging)
     echo -e "  $greenplus org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing"
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0         # Disables Inactive AC Timeout
     echo -e "  $greenplus org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0"
    # battery power
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type nothing # Disables automatic suspend on battery)
     echo -e "  $greenplus org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type nothing"
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0    # Disables Inactive Battery Timeout
     echo -e "  $greenplus org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0"
    # power button
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power power-button-action nothing         # Power button does nothing
     echo -e "  $greenplus org.gnome.settings-daemon.plugins.power power-button-action nothing"
    # idle brightness
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 0                   # Disables Idle Brightness
     echo -e "  $greenplus org.gnome.settings-daemon.plugins.power idle-brightness 0"
    # screensaver activation
    sudo -i -u $finduser gsettings set org.gnome.desktop.session idle-delay 0                                      # Disables Idle Activation of screensaver
     echo -e "  $greenplus org.gnome.desktop.session idle-delay 0"
    # screensaver lock
    sudo -i -u $finduser gsettings set org.gnome.desktop.screensaver lock-enabled false                            # Disables Locking
     echo -e "  $greenplus org.gnome.desktop.screensaver lock-enabled false\n"
}


First_Update () {

    cd $HOME
    if ! (git clone https://github.com/Dewalt-arch/pimpmykali.git) then 
        echo -e "\n $redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/Dewalt-arch/pimpmykali.git
    else 
        true;
    fi
    cd pimpmykali 
    ./pimpmykali.sh --upgrade
    cd $HOME
    rm -rf pimpmykali    
    apt install dkms build-essential linux-headers-amd64 kali-root-login gufw golang xrdp lcab docker-compose build-essential checkinstall autoconf automake autotools-dev m4 python3-venv gnome-terminal plank cargo docker.io tor lolcat xautomation guake starkiller open-vm-tools open-vm-tools-desktop fuse libssl-dev libffi-dev python-dev libpcap-dev python3-pip bettercap npm adb gcc-mingw-w64 libc6-dev python3.9-venv -y 
    apt remove powershell-empire -y
    apt purge powershell-empire -y
    apt install kali-root-login -y
}


WorkSpace () {
    echo -e "$greenplus Creating Wokspace"
    sleep 0.5
    echo -e "$greenplus Creating Folder: /root/HTB"
    mkdir /root/HTB
    sleep 0.5    
    echo -e "$greenplus Creating Folder: /root/OpenVPN"
    mkdir /root/OpenVPN
    sleep 0.5   
    echo -e "$greenplus Creating Folder: /root/PT"
    mkdir /root/PT
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools"
    mkdir /opt/Tools
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools/C2"        
    mkdir /opt/Tools/C2
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools/Enumeration"
    mkdir /opt/Tools/Enumeration
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools/Mobile"
    mkdir /opt/Tools/Mobile
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools/Payloads_gen"
    mkdir /opt/Tools/Payloads_gen
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools/Privilege-Escalation"
    mkdir /opt/Tools/Privilege-Escalation
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools/Web"
    mkdir /opt/Tools/Web
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools/Wifi"
    mkdir /opt/Tools/Wifi
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools/Active_Directory"
    mkdir /opt/Tools/Active_Directory
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools/Network"
    mkdir /opt/Tools/Network
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/Tools/General"
    mkdir /opt/Tools/General
    sleep 0.5
    cp  ./General/.zshrc /root/
    cp  ./General/.bashrc /root/ 
    mv ./replace.py /opt/Tools/General
    chmod +x /opt/Tools/General/replace.py
    ln -s /opt/Tools/General/replace.py /usr/bin/replace-line
    
    echo -e "$greenplus Setting Wallpapers"
    cp ./Wallpapers/wallpaper1.jpg /usr/share/backgrounds
    cp -R ./Wallpapers/* /root/Pictures/
    cp /root/Pictures/loginscreen.jpg /usr/share/desktop-base/kali-theme/login
    mv /usr/share/desktop-base/kali-theme/login/background /usr/share/desktop-base/kali-theme/login/background.original
    mv /usr/share/desktop-base/kali-theme/login/loginscreen.jpg /usr/share/desktop-base/kali-theme/login/background
    xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorVirtual1/workspace0/last-image --set /root/Pictures/wallpaper1.jpg

    # Pwnbox    
    echo -e "\n$greenplus Installing Pwnbox Stuff"
    mkdir /opt/Customize-Kali && mkdir /opt/Customize-Kali/gitclones 
    git -C /opt/Customize-Kali/gitclones/ clone https://github.com/theGuildHall/pwnbox.git
    cp ./General/banner /opt/Customize-Kali/gitclones/pwnbox/
    cp  ./General/banner.sh /opt/Customize-Kali/gitclones/pwnbox/ 
    cd /opt/Customize-Kali/gitclones/pwnbox
    cp -R bloodhound/ /opt/Tools/Enumeration && cp -R htb/ /opt/Customize-Kali && cp -R icons/ /opt/Customize-Kali/htb && cp banner /opt/Customize-Kali/htb && cp *.sh /opt/Customize-Kali/htb
    apt install -y powershell
    mkdir $HOME/.config/powershell
    cp /opt/Customize-Kali/gitclones/pwnbox/Microsoft.PowerShell_profile.ps1 $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1
    cp /opt/Customize-Kali/gitclones/pwnbox/htb.jpg /usr/share/backgrounds/
    cp -R /opt/Customize-Kali/gitclones/pwnbox/Material-Black-Lime-Numix-FLAT/ /usr/share/icons/
    cp -R /opt/Customize-Kali/gitclones/pwnbox/htb /usr/share/icons/
    mkdir /usr/share/themes/HackTheBox && cp /opt/Customize-Kali/gitclones/pwnbox/index.theme /usr/share/themes/HackTheBox
    xfconf-query -c xsettings -p /Net/IconThemeName -s Material-Black-Lime-Numix-FLAT
    xfconf-query -c xfwm4 -p /general/show_dock_shadow -s false
}


Pycharm () {

    finduser=$(logname)
    echo -e "\n$greenplus Installing Pycharm"
    cd  $HOME/Downloads
    wget  https://download.jetbrains.com/python/pycharm-community-2021.2.2.tar.gz
    tar xvzf $HOME/Downloads/pycharm-community*.tar.gz -C /tmp/ &> /dev/null
    chown -R $finduser:$finduser /tmp/pycharm*
    mv /tmp/pycharm-community* /opt/pycharm-community
    ln -s /opt/pycharm-community/bin/pycharm.sh /usr/local/bin/pycharm
    ln -s /opt/pycharm-community/bin/inspect.sh /usr/local/bin/inspect
    rm -r pycharm-community-2021.2.2.tar.gz 
    echo -e "$greenplus Pycharm successfully installed"
}

SublimeText () {

    echo -e "\n$greenplus Installing Sublime Text 3"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
    apt-get install apt-transport-https
    bash -c 'echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list'
    apt-get update
    apt-get install sublime-text
    echo -e "$greenplus Sublime Text 3 successfully installed"
}

Obsdian () {

    echo -e "\n$greenplus Installing Obsidian"
    cd /tmp
    wget "https://github.com/obsidianmd/obsidian-releases/releases/download/v0.12.15/Obsidian-0.12.15.AppImage" -O obsidian
    chmod +x obsidian
    mv obsidian /usr/bin/obsidian
    echo -e "$greenplus Obsdian successfully installed"
}

Chrome () {
    
    cd $HOME/Downloads
    echo -e "\n$greenplus Installing Chrome"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    dpkg -i ./google-chrome*.deb &> /dev/null
    apt-get install -f -y
    rm google-chrome-stable_current_amd64.deb
    replace-line 'deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main' 3 /etc/apt/sources.list.d/google-chrome.list  
    replace-line '# exec -a "$0" "$HERE/chrome" "$@" --user-data-dir --test-type --no-sandbox' 49 /opt/google/chrome/google-chrome 
    echo 'exec -a "$0" "$HERE/chrome" "$@" --no-sandbox' >> /opt/google/chrome/google-chrome
    echo -e "$greenplus Chrome successfully installed"
}

##################################################################
# PT Tools-Kit 
##################################################################

Web-Tools (){
    
    # Web Tools
    echo -e "\n$greenplus Installing Web-Tools"
    cd /opt/Tools/Web
    
    # Dirsearc
    echo -e "\n$greenplus Installing Dirsearch"
    if ! (git clone https://github.com/maurosoria/dirsearch.git) then
        echo -e "$redexclaim while donwloading, trying again in 10 seconds";sleep 10; git clone https://github.com/maurosoria/dirsearch.git
    else
        echo -e "$greenplus Dirsearch successfully installed"
    fi
    
    # magicRecon
    echo -e "\n$greenplus Installing magicRecon"
    if ! (git clone https://github.com/robotshell/magicRecon.git) then
        echo -e "$redexclaim while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/robotshell/magicRecon.git
    else
        echo -e "$greenplus magicRecon successfully installed"
    fi
    
    #fuff
    
    echo -e "\n$greenplus Installing fuff"
    if ! (git clone https://github.com/ffuf/ffuf) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10; git clone https://github.com/ffuf/ffuf
    else
        true;
    fi
    cd ffuf ; go get ; go build
    echo -e "$greenplus fuff successfully installed"
    
    cd /opt/Tools/General
    echo -e "\n$greenplus Installing duplicut"
    if ! (git clone https://github.com/nil0x42/duplicut) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/nil0x42/duplicut
    else
        true;
    fi

    cd duplicut/ && make &> /dev/null
    cp duplicut /usr/bin
    echo -e "$greenplus duplicut successfully installed"
    cd /opt/Tools/Web
    echo -e "\n$greenplus Installing OneListForAll"
    
    if ! (git clone https://github.com/six2dez/OneListForAll.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/six2dez/OneListForAll.git
    else
       true;
    fi

    cd OneListForAll
    ./olfa.sh
    echo -e "$greenplus OneListForAll successfully installed"
    
    cd /opt/Tools/Web
    echo -e "\n$greenplus Installing Reconky-Automated_Bash_Script"

    if ! (git clone https://github.com/ShivamRai2003/Reconky-Automated_Bash_Script.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/ShivamRai2003/Reconky-Automated_Bash_Script.git
    else
        true;
    fi 

    cd Reconky-Automated_Bash_Script
    replace-line "cd /opt/Tools/Web" 26 install.sh
    replace-line "    cd /opt/Tools/Web" 67 install.sh
    replace-line "    mkdir Reconky-tools" 68 install.sh
    replace-line "    cd Reconky-tools" 69 install.sh
    replace-line "    ln -sfv /opt/Tools/Web/Reconky-tools/Sublist3r/sublist3r.py /usr/bin/sublist3r" 75 install.sh
    replace-line "    cd /opt/Tools/Web/Reconky-tools" 81 install.sh
    
    chmod +x install.sh
    ./install.sh
    echo -e "$greenplus Reconky-Automated_Bash_Script successfully installed"
    
    cd /opt/Tools/Web
    echo -e "\n$greenplus Installing nuclei"
    if ! (git clone https://github.com/projectdiscovery/nuclei.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/projectdiscovery/nuclei.git
    else
        true;
    fi

    cd nuclei/v2/cmd/nuclei; \
    go build; \
    mv nuclei /usr/local/bin/; \
    nuclei -version;
    echo -e "$greenplus nuclei successfully installed"
    
    echo -e "\n$greenplus Donwloading  Nuclei-Templates"
    mkdir /opt/Tools/Web/Nuclei-Util

    cd /opt/Tools/Web/Nuclei-Util/
    (git clone https://github.com/ARPSyndicate/kenzer-templates.git)
    (git clone https://github.com/panch0r3d/nuclei-templates.git Nuclei-Templates1)
    (git clone https://github.com/medbsq/ncl.git)
    (git clone https://github.com/notnotnotveg/nuclei-custom-templates.git)
    (git clone https://github.com/foulenzer/foulenzer-templates.git)
    (git clone https://github.com/clarkvoss/Nuclei-Templates.git Nuclei-Templates2)
    (git clone https://github.com/z3bd/nuclei-templates.git Nuclei-Templates3)
    echo -e "$greenplus Nuclei-Templates successfully installed"
    
}


Wifi-Tools (){
    
    #Wifi Tools
    echo -e "\n$greenplus Installing Wifi-Tools"
    cd /opt/Tools/Wifi
    echo -e "\n$greenplus Installing OWT"
    
    if ! (git clone https://github.com/clu3bot/OWT.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/clu3bot/OWT.git
    else
        echo -e "$greenplus OWT successfully installed"
    fi

    echo -e "\n$greenplus Installing airgeddon"
    
    
    if ! (git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git
    else
        echo -e "$greenplus airgeddon successfully installed"
    fi
    
    echo -e "\n$greenplus Installing websploit"
    if ! (git clone https://github.com/websploit/websploit.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/websploit/websploit.git
    else
        true;
    fi
    
    cd websploit
    python3 setup.py install &> /dev/null
    echo -e "$greenplus websploit successfully installed"
    
}


Mobile-Tools (){
    
    # Mobsf
    echo -e "\n$greenplus Installing Mobile-Tools"
    cd /opt/Tools/Mobile
    echo -e "\n$greenplus Installing Mobsf"
    

    if ! (git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
    else
        true;
    fi   
    
    cd Mobile-Security-Framework-MobSF
    docker build -t mobsf . 
    echo 'docker run -it --rm -p 8000:8000 mobsf' >> /usr/bin/mobsf-start
    chmod +x /usr/bin/mobsf-start
    echo -e "$greenplus Mobile-Security-Framework-MobSF successfully installed"

    # Phonesploit
    cd /opt/Tools/Mobile
    echo -e "\n$greenplus Installing Phonesploit"
    
    if ! (git clone https://github.com/aerosol-can/PhoneSploit.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/aerosol-can/PhoneSploit.git
    else
        true;
    fi     
    
    cd PhoneSploit
    pip3 install colorama --quiet
    echo -e "$greenplus Phonesploit successfully installed"

    # SSL pining
    cd /opt/Tools/Mobile
    echo -e "\n$greenplus Installing AndroidPinning"
    
    if ! (git clone https://github.com/moxie0/AndroidPinning.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/moxie0/AndroidPinning.git
    else
        echo -e "$greenplus AndroidPinning successfully installed"
    fi     
    
}


C2-Tools (){

    echo -e "\n$greenplus Installing C2-Tools"
    # Evil-winrm
    cd /opt/Tools/C2
    echo -e "\n$greenplus Installing Evil-winrm"

    if ! (git clone --branch dev https://github.com/Hackplayers/evil-winrm.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/Hackplayers/evil-winrm.git
    else
        true;
    fi  
    gem install rubyntlm winrm winrm-fs stringio logger fileutils
    echo -e "$greenplus Evil-winrm successfully installed"

    # dnscat
    cd /opt/Tools/C2
    echo -e "\n$greenplus Installing dnscat2"
    
    if ! (git clone https://github.com/iagox86/dnscat2.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/iagox86/dnscat2.git
    else
        true;
    fi  
    
    cd dnscat2/server/
    bundle install
    echo -e "$greenplus dnscat2 successfully installed"
    
    # Pwncat
    cd /opt/Tools/C2
    echo -e "\n$greenplus Installing Pwncat"
    
    if ! (git clone https://github.com/calebstewart/pwncat.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/calebstewart/pwncat.git
    else
        true;
    fi
    
    cd pwncat
    python3 -m venv pwncat-env
    source pwncat-env/bin/activate
    python setup.py install &> /dev/null 
    pip install -r requirements.txt --quiet
    ln -s $PWD/pwncat-env/bin/pwncat /usr/bin/ 
    deactivate
    echo -e "$greenplus Pwncat successfully installed"

    # Empire
    cd /opt/Tools/C2
    echo -e "\n$greenplus Installing Empire & DeathStar"
    pip install poetry --quiet
    echo -e "\n$redstar Sleeping for 45 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 45
    
    if ! (git clone --recursive https://github.com/BC-SECURITY/Empire.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone --recursive https://github.com/BC-SECURITY/Empire.git
    else
        true;
    fi        
    
    cd Empire
    ./setup/install.sh
    poetry install
    python3 -m pip install pipx --quiet
    source $HOME/.profile
    pipx install deathstar-empire
    echo -e "$greenplus Empire successfully installed"
    
}


Enumeration-Tools (){

    #Enumeartion-Tools
    # Rustscan
    echo -e "\n$greenplus Installing Enumeration-Tools"
    cd /opt/Tools/Enumeration
    echo -e "\n $greenplus Installing Rustscan"
    
    if ! (git clone https://github.com/RustScan/RustScan.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/RustScan/RustScan.git
    else
        true;
    fi   
    
    cd RustScan
    cargo build --release
    echo 'command = ["-sC","-sV","-O","-Pn"]' >> ~/.rustscan.toml
    echo 'batch_size = 65535' >> ~/.rustscan.toml
    echo 'timeout = 3500' >> ~/.rustscan.toml
    echo 'ulimit = 7000' >> ~/.rustscan.toml
    echo -e "$greenplus RustScan successfully installed"

    # Enum4linux-ng
    cd /opt/Tools/Enumeration
    echo -e "\n$greenplus Installing Enum4linux-ng"
    
    if ! (git clone https://github.com/cddmp/enum4linux-ng.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/cddmp/enum4linux-ng.git
    else
        echo -e "$greenplus Enum4linux-ng successfully installed"
    fi 

    echo -e "\n$greenplus Installing dnsrecon"
    #dnsrecon
    if ! (git clone https://github.com/darkoperator/dnsrecon.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/darkoperator/dnsrecon.git
    else
        echo -e "$greenplus dnsrecon successfully installed"
    fi 
    
    echo -e "\n$greenplus Installing New Nmap NSE Scripts"
    # Nmap Vuln scan
    rm -rf /usr/share/nmap/scripts
    echo -e "$greenplus /usr/share/nmap/scripts removed "
    cd /tmp
    if ! (git clone https://github.com/nmap/nmap.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/nmap/nmap.git
    else
        true;
    fi     
    
    mv  nmap/scripts /usr/share/nmap/
    rm -rf nmap
    eval wget https://raw.githubusercontent.com/onomastus/pentest-tools/master/fixed-http-shellshock.nse -O /usr/share/nmap/scripts/http-shellshock.nse 
    echo -e "\n$greenplus /usr/share/nmap/script as updated"
    echo -e "$greenplus New Nmap NSE Scripts successfully installed"

    cd /usr/share/nmap/scripts
    echo -e "\n$greenplus Installing nmap-vulners"
    
    if ! (git clone https://github.com/vulnersCom/nmap-vulners.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/vulnersCom/nmap-vulners.git
    else
        true;
    fi 
    
    cp nmap-vulners/*.nse  /usr/share/nmap/scripts
    cp nmap-vulners/http-vulners-regex.json /usr/share/nmap/nselib/data/
    cp nmap-vulners/http-vulners-paths.txt /usr/share/nmap/nselib/data/
    rm -rf nmap-vulners
    echo -e "$greenplus nmap-vulners successfully installed"

    cd /opt/Tools/Enumeration
    mkdir /usr/share/nmap/scripts/vulscan
    
    echo -e "\n$greenplus Installing vulscan"
    if ! (git clone https://github.com/scipag/vulscan scipag_vulscan) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/scipag/vulscan scipag_vulscan
    else
        true;
    fi 
    
    ln -s $PWD/scipag_vulscan /usr/share/nmap/scripts/vulscan
    wget https://www.computec.ch/projekte/vulscan/download/cve.csv -O /usr/share/nmap/scripts/vulscan/cve.csv
    wget https://www.computec.ch/projekte/vulscan/download/exploitdb.csv -O /usr/share/nmap/scripts/vulscan/exploitdb.csv
    wget https://www.computec.ch/projekte/vulscan/download/openvas.csv -O /usr/share/nmap/scripts/vulscan/openvas.csv
    wget https://www.computec.ch/projekte/vulscan/download/osvdb.csv  -O /usr/share/nmap/scripts/vulscan/osvdb.csv
    wget https://www.computec.ch/projekte/vulscan/download/scipvuldb.csv  -O /usr/share/nmap/scripts/vulscan/scipvuldb.csv
    wget https://www.computec.ch/projekte/vulscan/download/securityfocus.csv  -O /usr/share/nmap/scripts/vulscan/securityfocus.csv
    wget https://www.computec.ch/projekte/vulscan/download/securitytracker.csv  -O /usr/share/nmap/scripts/vulscan/securitytracker.csv
    wget https://www.computec.ch/projekte/vulscan/download/xforce.csv   -O /usr/share/nmap/scripts/vulscan/xforce.csv
    echo -e "$greenplus vulscan successfully installed"

    echo -e "\n$greenplus Installing NSE Scripts"
    cd /opt/Tools/
    
    if ! (git clone https://github.com/s4n7h0/NSE.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/s4n7h0/NSE.git
    else
        true;
    fi   
    
    cd NSE
    cp *.nse /usr/share/nmap/scripts
    echo -e "$greenplus NSE scripts successfully installed"
    
    cd /opt/Tools/
    echo -e "\n$greenplus Installing Nmap NSE-Scripts"
    if ! (git clone https://github.com/psc4re/NSE-scripts.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/psc4re/NSE-scripts.git
    else
        true;
    fi
    
    cd NSE-scripts
    cp *.nse /usr/share/nmap/scripts
    
    rm /usr/share/nmap/scripts/ssl-enum-ciphers.nse
    rm -rf /opt/Tools/NSE-scripts
    rm -rf /opt/Tools/NSE
    nmap --script-updatedb
    echo -e "$greenplus Nmap NSE-scripts successfully installed"

    echo -e "\n$greenplus Installing Nmap Visulize Network"
    # Nmap Visulize Network
    cd /opt/Tools/Enumeration
    
    if ! (git clone https://github.com/tedsluis/nmap.git Nmap_Network-visualization) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10; git clone https://github.com/tedsluis/nmap.git Nmap_Network-visualization
    else
        true;
    fi                   
    
    cd Nmap_Network-visualization
    wget https://gojs.net/latest/release/go.js
    echo -e "$greenplus Nmap_Network-visualization successfully installed"
}


BloodHound (){

    
    cd /opt/Tools/Enumeration
    mkdir /opt/Tools/Enumeration/BloodHound
    cd /opt/Tools/Enumeration/BloodHound
    echo -e "\n$greenplus Installing Bloodhound & BloodHound Utils"
    echo -e "\n$greenplus Installing AzureHound"
    if ! (git clone https://github.com/BloodHoundAD/AzureHound.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/BloodHoundAD/AzureHound.git
    else
        echo -e "$greenplus AzureHound successfully installed"
    fi    
    
    echo -e "\n$greenplus Installing Bloodhound.py"
    if ! (git clone https://github.com/fox-it/BloodHound.py.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/fox-it/BloodHound.py.git
    else
        true;
    fi 
    
    cd BloodHound.py 
    pip install . --quiet
    echo -e "$greenplus BloodHound.py successfully installed"

    cd /opt/Tools/Enumeration/BloodHound
    mkdir /opt/Tools/Enumeration/BloodHound/BloodHound-Util
    cd /opt/Tools/Enumeration/BloodHound/BloodHound-Util
    
    echo -e "\n$greenplus Installing bloodhound-quickwin"
    if ! (git clone https://github.com/kaluche/bloodhound-quickwin.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/kaluche/bloodhound-quickwin.git
    else
        echo -e "$greenplus bloodhound-quickwin successfully installed"
    fi    
    
    pip3 install py2neo --quiet
    pip3 install pandas --quiet
    pip3 install prettytable --quiet
    
    echo -e "\n$greenplus Installing cypheroth"
    if ! (git clone https://github.com/seajaysec/cypheroth.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/seajaysec/cypheroth.git
    else
        echo -e "$greenplus cypheroth successfully installed"
    fi    
    
    cd /opt/Tools/Enumeration/BloodHound
    echo -e "\n$greenplus Installing Bloodhound"
    if ! (git clone https://github.com/BloodHoundAD/BloodHound.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/BloodHoundAD/BloodHound.git
    else
        true;
    fi 
    
    wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
    echo 'deb https://debian.neo4j.com stable 4.0' | sudo tee /etc/apt/sources.list.d/neo4j.list
    apt update
    apt install neo4j=1:4.0.8 -y
    cd BloodHound
    
    wget https://github.com/BloodHoundAD/BloodHound/releases/download/4.0.3/BloodHound-linux-x64.zip
    unzip BloodHound-linux-x64.zip &> /dev/null
    rm BloodHound-linux-x64.zip
    echo 'exec /opt/Tools/Enumeration/BloodHound/BloodHound/BloodHound-linux-x64/BloodHound --no-sandbox' > /usr/bin/bloodhound
    chmod +x /usr/bin/bloodhound
    mkdir /opt/Tools/Enumeration/start-bloodhound
    cp /opt/Tools/Enumeration/bloodhound/startBH.sh /opt/Tools/Enumeration/start-bloodhound/startBH.sh
    rm -rf /opt/Tools/Enumeration/bloodhound
    echo -e "$greenplus Bloodhound successfully installed"
}


Network-Tools () {
    # Networking Tools
    
    cd /opt/Tools/Network
    echo -e "\n$greenplus Installing Network-Tools"
    echo -e "\n$greenplus Installing PCredz"
    
    if ! (git clone https://github.com/lgandx/PCredz.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/lgandx/PCredz.git
    else
        echo -e "$greenplus PCredz successfully installed"
    fi 

    pip3 install Cython --quiet && pip3 install python-libpcap --quiet
    echo -e "\n$greenplus Installing mitm6"
    
    if ! (git clone https://github.com/fox-it/mitm6.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/fox-it/mitm6.git
    else
        echo -e "$greenplus mitm6 successfully installed"
    fi
    
}


Payloads-Tools (){

    # Payload Generetor
    # ysoserial
    cd /opt/Tools/Payloads_gen
    echo -e "\n$greenplus Installing Payloads-Tools"
    echo -e "\n$greenplus Installing ysoserial"
    mkdir ysoserial && cd ysoserial
    wget https://jitpack.io/com/github/frohoff/ysoserial/master-SNAPSHOT/ysoserial-master-SNAPSHOT.jar -O ysoserial.jar
    echo -e "$greenplus ysoserial successfully installed"
    
    # Invoke-Stealth
    cd /opt/Tools/Payloads_gen
    echo -e "\n$greenplus Installing Invoke-Stealth"
    if ! (git clone https://github.com/JoelGMSec/Invoke-Stealth.git) then
            echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/JoelGMSec/Invoke-Stealth.git
    else
        echo -e "$greenplus Invoke-Stealth successfully installed"
    fi
}


Tunneling-Tools (){

    echo -e "\n$greenplus Installing Tunneling-Tools"
    # Proxychains
    echo -e "\n$greenplus Installing proxychains-ng "
    mkdir /opt/Tools/Tunneling 
    cd /opt/Tools/Tunneling 
    
    apt purge proxychains4 -y && apt purge proxychains
    
    if ! (git clone https://github.com/rofl0r/proxychains-ng.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/rofl0r/proxychains-ng.git
    else
        true;
    fi
    
    cd proxychains-ng
    ./configure --prefix=/usr --sysconfdir=/etc &> /dev/null
    make &> /dev/null
    make install-config &> /dev/null
    ln -s $PWD/proxychains4 /usr/bin/proxychains
    replace-line "socks5 127.0.0.1 1080" 159 /etc/proxychains.conf
    echo "# sock4 127.0.0.1 9050" >> /etc/proxychains.conf
    echo -e "$greenplus proxychains-ng successfully installed"

    echo -e "\n$greenplus Installing Chisel"
    cd /opt/Tools/Tunneling
    mkdir Chisel
    cd /opt/Tools/Tunneling/Chisel
    wget https://github.com/jpillora/chisel/releases/download/v1.7.6/chisel_1.7.6_windows_amd64.gz -O chisel_Windows.gz
    gunzip chisel_Windows.gz &> /dev/null
    mv chisel_Windows chisel.exe 
    wget https://github.com/jpillora/chisel/releases/download/v1.7.6/chisel_1.7.6_linux_amd64.gz -O chisel.gz
    gunzip chisel.gz &> /dev/null
    echo -e "$greenplus chisel successfully installed"

    echo -e "\n$greenplus Installing pingtunnel"
    cd /opt/Tools/Tunneling
    mkdir pingtunnel && cd pingtunnel
    wget https://github.com/esrrhs/pingtunnel/releases/download/2.6/pingtunnel_windows_amd64.zip -O pingtunnel_windows.zip 
    unzip pingtunnel_windows.zip &> /dev/null
    wget https://github.com/esrrhs/pingtunnel/releases/download/2.6/pingtunnel_linux_amd64.zip -O pingtunnel_linux.zip
    unzip pingtunnel_linux.zip &> /dev/null
    rm pingtunnel_linux.zip
    rm pingtunnel_windows.zip
    echo -e "$greenplus pingtunnel successfully installed"

    # Ptunnel-ng
    echo -e "\n$greenplus Installing ptunnel-ng"
    cd /opt/Tools/Tunneling

    if ! (git clone https://github.com/lnslbrty/ptunnel-ng.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/lnslbrty/ptunnel-ng.git
    else
        true;
    fi
    
    cd ptunnel-ng
    wget https://github.com/lnslbrty/ptunnel-ng/releases/download/v1.42/ptunnel-ng-x64.exe -O ptunnel-ng.exe
    ./autogen.sh &> /dev/null
    echo -e "$greenplus ptunnel-ng successfully installed"

}


ActiveDirectory-Tools (){

    
    # impcaket
    echo -e "\n$greenplus Installing Active_Directory-Tools"
    cd /opt/Tools/Active_Directory
    echo -e "\n$greenplus Installing impacket"
    
    if ! (git clone https://github.com/SecureAuthCorp/impacket.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/SecureAuthCorp/impacket.git
    else
        true;
    fi

    cd impacket
    python3 -m venv impacket-env 
    source impacket-env/bin/activate
    python3 setup.py install &> /dev/null
    deactivate
    echo -e "$greenplus impacket successfully installed"

    # Zerologon
    cd /opt/Tools/Active_Directory
    mkdir Zerologon
    echo -e "\n$greenplus Installing Zerologon"
    cd Zerologon
    
    if ! (git clone https://github.com/Privia-Security/ADZero.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/Privia-Security/ADZero.git
        else
        echo -e "$greenplus ADZero successfully installed"
    fi    
    
    if ! (git clone https://github.com/dirkjanm/CVE-2020-1472.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/dirkjanm/CVE-2020-1472.git
    else
        echo -e "$greenplus CVE-2020-1472 successfully installed"
    fi        
    
    if ! (git clone https://github.com/sho-luv/zerologon.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/sho-luv/zerologon.git
    else
        echo -e "$greenplus zerologon successfully installed"
    fi    
    
    wget "https://raw.githubusercontent.com/SecuraBV/CVE-2020-1472/master/zerologon_tester.py" -O zerologon_tester.py
    
    #PrintNightmare
    echo -e "\n$redstar Sleeping for 45 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 45
    cd /opt/Tools/Active_Directory
    mkdir PrintNightmare
    echo -e "\n$greenplus Installing PrintNightmare"
    cd PrintNightmare
    python3 -m venv PrintNightmare-env
    source PrintNightmare-env/bin/activate
    
    if ! (git clone https://github.com/cube0x0/CVE-2021-1675.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/cube0x0/CVE-2021-1675.git
    else
        true;
    fi

    cd CVE-2021-1675
    
    curl https://raw.githubusercontent.com/SleepiPanda/CVE-2021-1675/bce1f74677c653ea8fc4babf96b7a55ec8f77be2/threaded_CVE-2021-1675.py -o threaded_CVE-2021-1675.py 
    echo -e "$greenplus CVE-2021-1675 successfully installed"
    cd ..
    
    echo -e "\n$greenplus Installing cube0x0-impacket"
    if ! (git clone https://github.com/cube0x0/impacket) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/cube0x0/impacket
    else
        true;
    fi
    cd impacket
    python3 ./setup.py install &> /dev/null
    deactivate
    echo -e "$greenplus cube0x0-impacket successfully installed"
    cd ..
    
    echo -e "\n$greenplus Installing ItWasAllADream"
    if ! (git clone https://github.com/byt3bl33d3r/ItWasAllADream) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/byt3bl33d3r/ItWasAllADream
    else
        true;
    fi    
    cd ItWasAllADream && poetry install
    touch start-env.sh
    echo -e '#!/bin/zsh \npoetry shell' > start-env.sh;chmod +x start-env.sh
    echo -e "$greenplus ItWasAllADream successfully installed"
    
    echo -e "\n$greenplus Installing PrintNightmare-PY"
    cd /opt/Tools/Active_Directory/PrintNightmare
    if ! (git clone https://github.com/ollypwn/PrintNightmare.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/ollypwn/PrintNightmare.git
    else
        echo -e "$greenplus PrintNightmare-PY successfully installed"
    fi    
    
    #PetitPotam
    echo -e "\n$greenplus Installing PetitPotam"
    cd /opt/Tools/Active_Directory

    if ! (git clone https://github.com/topotam/PetitPotam.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/topotam/PetitPotam.git
    else
        echo -e "$greenplus PetitPotam successfully installed"
    fi        
    
    echo -e "\n$greenplus Installing PetitPotam-PY"
    if ! (git clone https://github.com/ollypwn/PetitPotam.git PetitPotam-PY) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/ollypwn/PetitPotam.git PetitPotam-PY
    else
        echo -e "$greenplus PetitPotam-PY successfully installed"
    fi    
    

    #pypykatz
    echo -e "\n$greenplus Installing PypyKatz"
    pip3 install minidump minikerberos aiowinreg msldap winacl --quiet
    
    if ! (git clone https://github.com/skelsec/pypykatz.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/skelsec/pypykatz.git
    else
        true;
    fi    
    
    cd pypykatz
    python3 setup.py install &> /dev/null
    echo -e "$greenplus pypykatz successfully installed"
}


Utils-Tools (){
    echo -e "\n$greenplus Installing Utils-Tools"
    Pycharm
    SublimeText
    Obsdian
    Chrome
    
}


General_Stuff () {

    echo -e "\n$greenplus Installing & Fixing General Stuff"
    # Stabilize Shell
    cd /opt/Tools/General
    echo -e "\n$greenplus Installing poor-mans-pentest"
    if ! (git clone https://github.com/JohnHammond/poor-mans-pentest.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/JohnHammond/poor-mans-pentest.git
    else
        true;
    fi

    cd poor-mans-pentest
    replace-line '    xte "key F12"' 15 functions.sh
    replace-line 'call_cmd "/usr/bin/script -qc /bin/bash /dev/null"' 6 stabilize_zsh_shell.sh
    replace-line 'source "/opt/Tools/General/poor-mans-pentest/functions.sh"' 3 stabilize_zsh_shell.sh
    echo 'call_cmd "exec clear"' >> stabilize_zsh_shell.sh
    ln -s /opt/Tools/General/poor-mans-pentest/stabilize_zsh_shell.sh /usr/bin/stabilize_shell
    echo -e "$greenplus poor-mans-pentest successfully installed"

    # bat
    cd ~
    echo -e "\n$greenplus Installing bat"
    cargo install --locked bat
    ln -s /root/.cargo/bin/bat /usr/bin/bat
    bat --generate-config-file
    echo '--pager="cat"' >  /root/.config/bat/config
    echo -e "$greenplus BAT successfully installed" 

    echo -e "\n$greenplus Fixing Pip For python 2.7 "
    check_pip=$(pip --version | grep -i -c "/usr/local/lib/python2.7/dist-packages/pip")
    if [ $check_pip -ne 1 ]
     then
      echo -e "\n$greenplus installing pip"
      # 01.26.2021 - get-pip.py throwing an error, commented out and pointed wget directly to the python2.7 get-pip.py
      # eval curl curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py $silent
      eval curl https://raw.githubusercontent.com/pypa/get-pip/3843bff3a0a61da5b63ea0b7d34794c5c51a2f11/2.7/get-pip.py -o /tmp/get-pip.py $silent
      eval python /tmp/get-pip.py $silent
      rm -f /tmp/get-pip.py
      eval pip install setuptools
      echo -e "\n$greenplus   python-pip installed"
    else
      echo -e "\n$greenminus  python-pip already installed"
    fi
    echo -e "\n$greenplus Installing pimpmykali"
    cd /opt/Tools/General
    if ! (git clone https://github.com/Dewalt-arch/pimpmykali.git) then 
        echo -e "$redexclaim Error while donwloading, trying again in 10 seconds";sleep 10;git clone https://github.com/Dewalt-arch/pimpmykali.git
    else 
        true;
    fi
    cd pimpmykali
    ./pimpmykali.sh --smb; \
    ./pimpmykali.sh --go; \
    ./pimpmykali.sh --grub; \
    ./pimpmykali.sh --flameshot; \
    ./pimpmykali.sh --nmap; \
    ./pimpmykali.sh --mirrors; \
    echo -e "$greenplus pimpmykali successfully installed"

    gzip -dq /usr/share/wordlists/rockyou.txt.gz
    echo -e "\n$greenplus gunzip /usr/share/wordlists/rockyou.txt.gz\n"
    
    #replace-line "autologin-user=root" 126 /etc/lightdm/lightdm.conf
    #replace-line "autologin-user-timeout=" 127 /etc/lightdm/lightdm.conf

    echo -e "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
    updatedb
    msfdb init
    echo -e "$greenplus Done doing General Stuff\n"
    apt update && apt full-upgrade -y && apt autoremove -y && echo -e "\n$fourblinkexclaim Rebooting in 60 seconds...." ;sleep 60;  reboot

}


if [ "$EUID" -ne 0 ]
    then echo  "$redexclaim This Script must be run with sudo"
    exit
fi

apt -qq list kali-root-login | grep 'installed' &> /dev/null
if [ $? == 0 ]; then
    systemctl enable docker
    systemctl enable openvpn 
    WorkSpace
    
    C2-Tools
    echo -e "$greenplus Done installing C2-Tools"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60

    Mobile-Tools
    echo -e "$greenplus Done installing Mobile-Tools"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60

    Web-Tools
    echo -e "$greenplus Done installing Web-Tools"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60

    Wifi-Tools
    echo -e "$greenplus Done installing Wifi-Tools"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60

    Network-Tools
    echo -e "$greenplus Done installing Network-Tools"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60
    
    Payloads-Tools
    echo -e "$greenplus Done installing Payloads-Tools"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60
    

    Enumeration-Tools
    echo -e "$greenplus Done installing Enumeration-Tools"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60

    BloodHound
    echo -e "$greenplus Done installing Bloodhound"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60


    Tunneling-Tools
    echo -e "$greenplus Done installing Tunneling-Tools"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60

    ActiveDirectory-Tools
    echo -e "$greenplus Done installing ActiveDirectory-Tools"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60

    Utils-Tools
    echo -e "$greenplus Done installing Utils-Tools"
    echo -e "\n$redstar Sleeping for 60 seconds cuz GitHub dosent let clone repos fast and blocking connection"
    sleep 60

    General_Stuff
    

else
    systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target;
    disable_power_gnome
    First_Update 
    apt update --fix-missing && apt full-upgrade -y && apt autoremove -y;
    echo -e "\n$greenplus Enabling Root Login Give root a password";
    passwd root;
    echo -e "$redexclaim root login enabled \n";
    sleep 1; 
    
    finduser=$(logname)
    eval cp -Rvf  /home/$finduser/* /home/$finduser/.* /root >/dev/null 2>&1
    eval chown -R root:root /root
    raw_xfce="https://raw.githubusercontent.com/Dewalt-arch/pimpmyi3-config/main/xfce4/xfce4-power-manager.xml"
    eval wget $raw_xfce -O /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
    eval wget $raw_xfce -O /home/$finduser/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
    echo -e "$redexclaim rebooting in 20 seconds...";
    sleep 20
    reboot;
    
fi
