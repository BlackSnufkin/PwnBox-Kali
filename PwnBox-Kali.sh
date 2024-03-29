#!/bin/bash

#########################################################
# ***       BlackSnufkin PwnBox-Kali                *** #
#                   Version 3.2                         #
#    Autemated the process of installing and update     #
#                                                       #
#                New Kali-Linux VM                      #
#                                                       #
#                                                       #
# ***               Updated: 30/12/21               *** #
#########################################################


exec 5> >(logger -t $0)
#exec 5> Debug.log 
BASH_XTRACEFD="5"
PS4='$LINENO: '
set -x

export DEBIAN_FRONTEND=noninteractive

# status indicators
greenplus='\e[1;33m[++]\e[0m'
greenminus='\e[1;33m[--]\e[0m'
redminus='\e[1;31m[--]\e[0m'
redexclaim='\e[1;31m[!!]\e[0m'
redstar='\e[1;31m[**]\e[0m'
blinkexclaim='\e[1;31m[\e[5;31m!!\e[0m\e[1;31m]\e[0m'
fourblinkexclaim='\e[1;31m[\e[5;31m!!!!\e[0m\e[1;31m]\e[0m'

finduser=$(logname)
detected_env=""


Fix_SourceList(){
  check_space=$(cat /etc/apt/sources.list | grep -c "# deb-src http://.*/kali kali-rolling.*")
  check_nospace=$(cat /etc/apt/sources.list | grep -c "#deb-src http://.*/kali kali-rolling.*")
  get_current_mirror=$(cat /etc/apt/sources.list | grep "deb-src http://.*/kali kali-rolling.*" | cut -d "/" -f3)
    if [[ $check_space = 0 && $check_nospace = 0 ]]; then
      echo -e "\n$greenminus # deb-src or #deb-sec not found - skipping"
    elif [ $check_space = 1 ]; then
      echo -e "\n$greenplus # deb-src with space found in sources.list uncommenting and enabling deb-src"
      sed 's/\# deb-src http\:\/\/.*\/kali kali-rolling.*/\deb-src http\:\/\/'$get_current_mirror'\/kali kali-rolling main contrib non\-free''/' -i /etc/apt/sources.list
      echo -e "\n$greenplus new /etc/apt/sources.list written with deb-src enabled"
    elif [ $check_nospace = 1 ]; then
      echo -e "\n$greenplus #deb-src without space found in sources.list uncommenting and enabling deb-src"
      sed 's/\#deb-src http\:\/\/.*\/kali kali-rolling.*/\deb-src http\:\/\/'$get_current_mirror'\/kali kali-rolling main contrib non\-free''/' -i /etc/apt/sources.list
      echo -e "\n$greenplus new /etc/apt/sources.list written with deb-src enabled"
    fi
  
}


Install_pkg () {

    REQUIRED_PKG="$1"
    echo -e "\n$greenplus Checking PKG: $REQUIRED_PKG"
    dpkg --status $REQUIRED_PKG &> /dev/null
    if [ $? -eq 0 ]; then
        echo -e "\n$greenplus PKG Status: Installed"
        echo -e "\n$redstar Skiping..."
    else
        echo -e "\n$redexclaim PKG Status: Not Installed.\n$redstar Installing: $REQUIRED_PKG.\n"
        if ! (apt-get install -y $REQUIRED_PKG) then
            echo -e "\n$redexclaim Error while donwloading $REQUIRED_PKG, \n$redstar trying again in 30 seconds\n";sleep 30;apt-get install -y $REQUIRED_PKG
        else 
            echo -e "\n$greenplus $REQUIRED_PKG Installed Successfully\n";
        fi
        sleep 1
    fi

}

GetTool () {

    if [ "$#" -eq 1 ]; then
        name=$(echo $1 | awk -F '/' '{print $5}' | awk -F'.' '{print $1}')
        echo -e "\n$greenplus Downloading: $name \n$greenplus Location: $PWD/$name \n" 
    
        if ! (git clone $1 ) then
            echo -e "$redexclaim Error while donwloading $name, \n$redstar trying again in 30 seconds";sleep 30;git clone $1 $2
        else
            echo -e "\n$greenplus $name donwloaded successfully\n";
        fi
    else
        name=$(echo $1 | awk -F '/' '{print $5}' | awk -F'.' '{print $1}')
        echo -e "\n$greenplus Downloading: $name \n$greenplus Alternate Name: $2 \n$greenplus Location: $PWD/$2 \n" 
        
        if ! (git clone $1 $2) then
            echo -e "$redexclaim Error while donwloading $name, \n$redstar trying again in 30 seconds";sleep 30;git clone $1 $2
        else
            echo -e "\n$greenplus $2 Donwloaded Successfully\n";
        fi  
    fi
}


check_reboot () {
    if [ -f /var/run/reboot-required ];then
        echo  -e "\n$blinkexclaim Reboot required \n$blinkexclaim Rebooting in 10 Seconds";sleep 10;reboot -f
    else
        echo  -e "\n$greenplus No reboot required"
        true
    fi
}

Update () { 

    apt update && apt full-upgrade -y && apt autoremove -y
}


FixUpdate () { 

    apt update --fix-missing && apt full-upgrade -y && apt autoremove -y 
}


Fix_hushlogin() {
    echo -e "\n$greenplus Checking for .hushlogin"
    if [ $finduser = "root" ]
     then
      if [ -f /root/.hushlogin ]
       then
        echo -e "\n$greenminus /$finduser/.hushlogin exists - skipping"
      else
        echo -e "\n$greenplus Creating file /$finduser/.hushlogin"
        touch /$finduser/.hughlogin
      fi
    else
      if [ -f /home/$finduser/.hushlogin ]
       then
        echo -e "\n$greenminus /home/$finduser/.hushlogin exists - skipping"
      else
        echo -e "\n$greenplus Creating file /home/$finduser/.hushlogin"
        touch /home/$finduser/.hushlogin
      fi
    fi
}


disable_power_gnome() {
    # CODE CONTRIBUTION : pswalia2u - https://github.com/pswalia2u
    Fix_hushlogin
    echo -e "\n$greenplus Gnome detected - Disabling Power Savings"
    # ac power
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing      # Disables automatic suspend on charging)
     echo -e "$greenplus org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing"
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0         # Disables Inactive AC Timeout
     echo -e "  $greenplus org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0"
    # battery power
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type nothing # Disables automatic suspend on battery)
     echo -e "$greenplus org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type nothing"
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0    # Disables Inactive Battery Timeout
     echo -e "$greenplus org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0"
    # power button
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power power-button-action nothing         # Power button does nothing
     echo -e "$greenplus org.gnome.settings-daemon.plugins.power power-button-action nothing"
    # idle brightness
    sudo -i -u $finduser gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 0                   # Disables Idle Brightness
     echo -e "$greenplus org.gnome.settings-daemon.plugins.power idle-brightness 0"
    # screensaver activation
    sudo -i -u $finduser gsettings set org.gnome.desktop.session idle-delay 0                                      # Disables Idle Activation of screensaver
     echo -e "$greenplus org.gnome.desktop.session idle-delay 0"
    # screensaver lock
    sudo -i -u $finduser gsettings set org.gnome.desktop.screensaver lock-enabled false                            # Disables Locking
     echo -e "$greenplus org.gnome.desktop.screensaver lock-enabled false\n"
}

# 06.18.2021 - disable_power_xfce rev 1.2.9 replaces fix_xfce_power fix_xfce_user and fix_xfce_root functions
disable_power_xfce() {
    Fix_hushlogin
    raw_xfce="https://raw.githubusercontent.com/Dewalt-arch/pimpmyi3-config/main/xfce4/xfce4-power-manager.xml"
    if [ $finduser = "root" ]
     then
      echo -e "\n$greenplus XFCE Detected - disabling xfce power management \n"
      eval wget -q --show-progress --progress=bar:force:noscroll $raw_xfce -O /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
      echo -e "\n$greenplus XFCE power management disabled for user: $finduser \n"
    else
      echo -e "\n$greenplus XFCE Detected - disabling xfce power management \n"
      eval wget -q --show-progress --progress=bar:force:noscroll $raw_xfce -O /home/$finduser/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
      echo -e "\n$greenplus XFCE power management disabled for user: $finduser \n"
    fi
}


disable_power_checkde() {
    detect_xfce=$(ps -e | grep -c -E '^.* xfce4-session$')
    detect_gnome=$(ps -e | grep -c -E '^.* gnome-session-*')
    [ $detect_gnome -ne 0 ] && detected_env="GNOME"
    [ $detect_xfce -ne 0 ] && detected_env="XFCE"

    echo -e "\n$greenplus Detected Environment: $detected_env"
    [ $detected_env = "GNOME" ] && disable_power_gnome
    [ $detected_env = "XFCE" ] && disable_power_xfce
    [ $detected_env = "" ] && echo -e"\n  $redexclaim Unable to determine desktop environment"

}


Update_and_install () {

    Fix_SourceList
    Update
    echo -e "\n$greenplus Starting to install dependencies"
    pkgs=("dkms" "build-essential" "linux-headers-amd64" "gufw" "golang" "xrdp" "docker-compose" "lcab" "checkinstall" "autoconf" "automake" "python2-dev" "autotools-dev" "m4" "python3-venv" "gnome-terminal" "plank" "cargo" "docker.io" "tor" "torbrowser-launcher" "lolcat" "xautomation" "guake" "starkiller" "open-vm-tools" "open-vm-tools-desktop" "fuse3" "libssl-dev" "libxml2-dev" "libxslt1-dev" "libffi-dev" "python3-pip" "bettercap" "npm" "python3.9-dev" "libpcap-dev" "adb" "gcc-mingw-w64" "libc6-dev" "python3.9-venv" "python3-pyqt5" "libssl-dev" "figlet" "toilet" "powershell" "libpcap0.8" "mingw-w64-tools" "mingw-w64-common" "libffi-dev" "g++-mingw-w64" "upx-ucl" "seclists" "osslsigncode" "nim" "jq" "ruby-full"  "libxml2" "ruby-dev" "libgmp-dev" "zlib1g-dev" "libssl-dev"  "python-setuptools" "libldns-dev" "python3-dnspython" "rename" "xargs" "snapd" "tree")
    for i in "${pkgs[@]}"; do Install_pkg "$i"; done
    apt remove proxychains4 spiderfoot -y

    # pimpmykali
    cd $HOME
    GetTool https://github.com/Dewalt-arch/pimpmykali.git
    cd pimpmykali 
    ./pimpmykali.sh --upgrade; \
    ./pimpmykali.sh --root; \
    cd $HOME
    rm -rf pimpmykali
    FixUpdate && check_reboot

    
}


SpinUp_Workspace () {
    
    echo -e "\n$greenplus Creating Workspace"
    sleep 0.5
    
    echo -e "$greenplus Creating Folder: /root/HTB"
    mkdir /root/HTB
    sleep 0.5    
    
    echo -e "$greenplus Creating Folder: /root/OpenVPN"
    mkdir /root/OpenVPN
    sleep 0.5   
    
    echo -e "$greenplus Creating Folder: /root/PT-Projects"
    mkdir  /root/PT-Projects/
    sleep 0.5
    
    echo -e "$greenplus Creating Folder: /root/PT-Projects/Obsidian_Vault"
    mkdir  /root/PT-Projects/Obsidian_Vault
    sleep 0.5

    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit"
    mkdir /opt/RedTeam-ToolKit
    sleep 0.5

    # Recon 
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Recon"
    mkdir /opt/RedTeam-ToolKit/Recon
    sleep 0.5
    
    # C2
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/C2"        
    mkdir /opt/RedTeam-ToolKit/C2
    sleep 0.5
 
    # Web
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Web"
    mkdir /opt/RedTeam-ToolKit/Web
    sleep 0.5

    # Wifi
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Wifi"
    mkdir /opt/RedTeam-ToolKit/Wifi
    sleep 0.5
    
    # Mobile
    #echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Mobile"
    #mkdir /opt/RedTeam-ToolKit/Mobile
    #sleep 0.5

    # Network
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Network"
    mkdir /opt/RedTeam-ToolKit/Network
    sleep 0.5

    # Tunneling
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Tunneling"
    mkdir /opt/RedTeam-ToolKit/Tunneling
    sleep 0.5

    # Payload Development
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Payload_Dev"
    mkdir /opt/RedTeam-ToolKit/Payload_Dev
    sleep 0.5
    
    # Initial_Access
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Initial_Access"
    mkdir /opt/RedTeam-ToolKit/Initial_Access
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Initial_Access/Phishing"
    mkdir /opt/RedTeam-ToolKit/Initial_Access/Phishing
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Initial_Access/BruteForce"
    mkdir /opt/RedTeam-ToolKit/Initial_Access/BruteForce
    sleep 0.5

    # Active Directory
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Active-Directory"
    mkdir /opt/RedTeam-ToolKit/Active_Directory
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Active-Directory/Enumeration"
    mkdir /opt/RedTeam-ToolKit/Active_Directory/Enumeration
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Active-Directory/Credential_Dumping"
    mkdir /opt/RedTeam-ToolKit/Active_Directory/Credential_Dumping
    sleep 0.5
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Active-Directory/Offensive-Tools"
    mkdir /opt/RedTeam-ToolKit/Active_Directory/Offensive-Tools
    sleep 0.5

    # General
    echo -e "$greenplus Creating Folder: /opt/RedTeam-ToolKit/Resources"
    mkdir /opt/RedTeam-ToolKit/Resources
    sleep 0.5

    cp  ./Resources/.zshrc $HOME
    cp  ./Resources/.bashrc $HOME 
    mv ./Resources/replace.py /opt/RedTeam-ToolKit/Resources
    chmod +x /opt/RedTeam-ToolKit/Resources/replace.py
    ln -s /opt/RedTeam-ToolKit/Resources/replace.py /usr/bin/replace-line
    
    echo -e "\n$greenplus Setting Wallpapers"
    cp ./Wallpapers/wallpaper1.jpg /usr/share/backgrounds
    cp -R ./Wallpapers/* /root/Pictures/
    cp /root/Pictures/loginscreen.jpg /usr/share/desktop-base/kali-theme/login
    mv /usr/share/desktop-base/kali-theme/login/background /usr/share/desktop-base/kali-theme/login/background.original
    mv /usr/share/desktop-base/kali-theme/login/loginscreen.jpg /usr/share/desktop-base/kali-theme/login/background
    xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorVirtual1/workspace0/last-image --set /root/Pictures/wallpaper1.jpg

    # Pwnbox    
    GetTool https://github.com/theGuildHall/pwnbox.git
    mv pwnbox /opt/
    rm /opt/pwnbox/banner
    rm /opt/pwnbox/banner.sh
    cp ./Resources/banner /opt/pwnbox/
    cp  ./Resources/banner.sh /opt/pwnbox/ 
    cp  ./Resources/net.sh /opt/pwnbox/ 
    cp ./Resources/Microsoft.PowerShell_profile.ps1 $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1
    chmod +x /opt/pwnbox/banner.sh
    chmod +x /opt/pwnbox/net.sh 
    cd /opt/pwnbox
    cp /opt/pwnbox/htb.jpg /usr/share/backgrounds/
    echo -e "\n$greenplus Setting HackTheBox theme"
    cp -R /opt/pwnbox/Material-Black-Lime-Numix-FLAT/ /usr/share/icons/
    cp -R /opt/pwnbox/htb /usr/share/icons/
    mkdir /usr/share/themes/HackTheBox && cp /opt/pwnbox/index.theme /usr/share/themes/HackTheBox
    xfconf-query -c xsettings -p /Net/IconThemeName -s Material-Black-Lime-Numix-FLAT
    xfconf-query -c xfwm4 -p /general/show_dock_shadow -s false

}


Pycharm () {

    finduser=$(logname)
    echo -e "\n$greenplus Installing Pycharm"
    cd  $HOME/Downloads
    wget -q --show-progress --progress=bar:force:noscroll https://download.jetbrains.com/python/pycharm-community-2021.2.2.tar.gz
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
    set -euo pipefail
    icon_url="https://cdn.discordapp.com/icons/686053708261228577/1361e62fed2fee55c7885103c864e2a8.png"
    dl_url="https://github.com/obsidianmd/obsidian-releases/releases/download/v0.12.19/Obsidian-0.12.19.AppImage"
    curl --location --output Obsidian.AppImage "$dl_url"
    curl --location --output obsidian.png "$icon_url"
    mkdir --parents /usr/share/obsidian
    mv Obsidian.AppImage /usr/share/obsidian
    chmod u+x /usr/share/obsidian/Obsidian.AppImage
    mv obsidian.png /usr/share/obsidian
    ln -s /usr/share/obsidian/obsidian.png /usr/share/pixmaps
    echo "[Desktop Entry]
    Type=Application
    Name=Obsidian
    Exec=/usr/share/obsidian/Obsidian.AppImage --no-sandbox
    Icon=obsidian
    Terminal=false" > /usr/share/applications/obsidian.desktop
    update-desktop-database /usr/share/applications
    echo -e "$greenplus Obsdian successfully installed"
}


Chrome () {
    
    cd $HOME/Downloads
    echo -e "\n$greenplus Installing Chrome"
    wget -q --show-progress --progress=bar:force:noscroll https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    dpkg -i ./google-chrome*.deb &> /dev/null
    apt-get install -f -y
    rm google-chrome-stable_current_amd64.deb
    replace-line 'deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main' 3 /etc/apt/sources.list.d/google-chrome.list  
    replace-line '# exec -a "$0" "$HERE/chrome" "$@" --user-data-dir --test-type --no-sandbox' 49 /opt/google/chrome/google-chrome 
    echo 'exec -a "$0" "$HERE/chrome" "$@" --no-sandbox' >> /opt/google/chrome/google-chrome
    echo -e "$greenplus Chrome successfully installed"
}


Utils-Tools (){
    echo -e "\n$greenplus Installing Utils-Tools"
    Pycharm
    SublimeText
    Obsdian
    Chrome
    sleep 0.5
    echo -e "\n$greenplus Utils-Tools successfully installed"
    sleep 0.5
}


##################################################################
# RedTeam-ToolKit 
##################################################################


Recon-Tools () {

    # Rustscan
    echo -e "\n$greenplus Downloading & Installing Recon Tools"
    RECON_DIR=/opt/RedTeam-ToolKit/Recon
    
    cd $RECON_DIR
    GetTool https://github.com/RustScan/RustScan.git
    cd RustScan
    cargo build --release
    echo 'command = ["-sC","-sV","-O","-Pn","-f","--mtu 24","-D RND:10","-g 53","-sS"]' >> ~/.rustscan.toml
    echo 'batch_size = 65535' >> ~/.rustscan.toml
    echo 'timeout = 3500' >> ~/.rustscan.toml
    echo 'ulimit = 7000' >> ~/.rustscan.toml
    echo -e "\n$greenplus RustScan successfully installed"

    #SpiderFoot
    echo -e "\n$greenplus Installing SpiderFoot"
    cd $RECON_DIR
    wget -q --show-progress --progress=bar:force:noscroll https://github.com/smicallef/spiderfoot/archive/v3.5.tar.gz
    tar zxvf v3.5.tar.gz > /dev/null
    rm -rf v3.5.tar.gz
    mv spiderfoot-3.5 SpiderFoot
    cd SpiderFoot
    echo -e "$greenplus starting to install spiderfoot requirements "
    pip3 install --no-cache-dir -r requirements.txt --quiet
    echo -e "\n$greenplus spiderfoot successfully installed"

    # witnessme
    echo -e "\n$greenplus Intalling witnessme"
    echo -e "$greenplus starting to install witnessme requirements "
    pip3 install pipx --quiet
    pipx ensurepath
    pipx install witnessme
    echo -e "\n$greenplus witnessme successfully installed"


    # GoMapEnum
    cd $RECON_DIR
    GetTool https://github.com/nodauf/GoMapEnum.git
    echo -e "\n$greenplus GoMapEnum successfully installed"
    
    # pagodo
    cd $RECON_DIR
    GetTool https://github.com/opsdisk/pagodo.git
    cd pagodo
    echo -e "$greenplus starting to install pagodo requirements "
    pip3 install --no-cache-dir -r requirements.txt --quiet
    python3 ghdb_scraper.py -s -j -i 
    echo -e "\n$greenplus pagodo successfully installed"


    # CrossLinked
    cd $RECON_DIR
    GetTool https://github.com/m8r0wn/crosslinked.git
    cd crosslinked
    echo -e "$greenplus starting to install crosslinked requirements "
    pip3 install --no-cache-dir -r requirements.txt --quiet
    echo -e "\n$greenplus crosslinked successfully installed"

    # LinkedInt
    cd $RECON_DIR
    GetTool https://github.com/vysecurity/LinkedInt.git
    cd LinkedInt
    pip3 install --no-cache-dir -r requirements.txt --quiet
    echo -e "\n$greenplus LinkedInt successfully installed"

    # o365enum
    cd $RECON_DIR
    GetTool https://github.com/gremwell/o365enum.git
    echo -e "\n$greenplus o365enum successfully installed"

    #dnsrecon
    cd $RECON_DIR
    GetTool https://github.com/darkoperator/dnsrecon.git
    echo -e "\n$greenplus dnsrecon successfully installed"


    # Nmap Utils & NSE Scripts
    echo -e "\n$greenplus Installing New Nmap NSE Scripts"
    eval wget -q --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/onomastus/pentest-tools/master/fixed-http-shellshock.nse -O /usr/share/nmap/scripts/http-shellshock.nse 
    echo -e "\n$greenplus /usr/share/nmap/script as updated"
    echo -e "\n$greenplus New Nmap NSE Scripts successfully installed"

    cd /usr/share/nmap/scripts
    GetTool https://github.com/vulnersCom/nmap-vulners.git
    
    cp nmap-vulners/*.nse  /usr/share/nmap/scripts
    cp nmap-vulners/http-vulners-regex.json /usr/share/nmap/nselib/data/
    cp nmap-vulners/http-vulners-paths.txt /usr/share/nmap/nselib/data/
    rm -rf nmap-vulners
    echo -e "\n$greenplus nmap-vulners successfully installed"

    cd $RECON_DIR
    mkdir Nmap-Utils
    cd Nmap-Utils
    GetTool https://github.com/scipag/vulscan.git scipag_vulscan 
    mkdir /usr/share/nmap/scripts/vulscan
    ln -s $PWD/scipag_vulscan /usr/share/nmap/scripts/vulscan

    echo -e "\n$greenplus Downloading cve.csv"
    wget -q --show-progress --progress=bar:force:noscroll https://www.computec.ch/projekte/vulscan/download/cve.csv -O /usr/share/nmap/scripts/vulscan/cve.csv
    
    echo -e "\n$greenplus Downloading exploitdb.csv"
    wget -q --show-progress --progress=bar:force:noscroll https://www.computec.ch/projekte/vulscan/download/exploitdb.csv -O /usr/share/nmap/scripts/vulscan/exploitdb.csv
    
    echo -e "\n$greenplus Downloading openvas.csv"
    wget -q --show-progress --progress=bar:force:noscroll https://www.computec.ch/projekte/vulscan/download/openvas.csv -O /usr/share/nmap/scripts/vulscan/openvas.csv
    
    echo -e "\n$greenplus Downloading osvdb.csv"
    wget -q --show-progress --progress=bar:force:noscroll https://www.computec.ch/projekte/vulscan/download/osvdb.csv -O /usr/share/nmap/scripts/vulscan/osvdb.csv
    
    echo -e "\n$greenplus Downloading scipvuldb.csv"
    wget -q --show-progress --progress=bar:force:noscroll https://www.computec.ch/projekte/vulscan/download/scipvuldb.csv -O /usr/share/nmap/scripts/vulscan/scipvuldb.csv
    
    echo -e "\n$greenplus Downloading securityfocus.csv"
    wget -q --show-progress --progress=bar:force:noscroll https://www.computec.ch/projekte/vulscan/download/securityfocus.csv -O /usr/share/nmap/scripts/vulscan/securityfocus.csv
    
    echo -e "\n$greenplus Downloading securitytracker.csv"
    wget -q --show-progress --progress=bar:force:noscroll https://www.computec.ch/projekte/vulscan/download/securitytracker.csv -O /usr/share/nmap/scripts/vulscan/securitytracker.csv
    
    echo -e "\n$greenplus Downloading xforce.csv"
    wget -q --show-progress --progress=bar:force:noscroll https://www.computec.ch/projekte/vulscan/download/xforce.csv -O /usr/share/nmap/scripts/vulscan/xforce.csv
    
    echo -e "\n$greenplus vulscan successfully installed"

    # NSE
    cd $RECON_DIR/Nmap-Utils
    GetTool https://github.com/s4n7h0/NSE.git   
    cd NSE
    cp *.nse /usr/share/nmap/scripts
    
    
    # NSE-scripts
    cd $RECON_DIR/Nmap-Utils
    GetTool https://github.com/psc4re/NSE-scripts.git
    
    cd NSE-scripts
    cp *.nse /usr/share/nmap/scripts
    cd $RECON_DIR/Nmap-Utils 
    rm /usr/share/nmap/scripts/ssl-enum-ciphers.nse
    rm -rf /opt/RedTeam-ToolKit/Recon/Nmap-Utils/NSE-scripts
    rm -rf /opt/RedTeam-ToolKit/Recon/Nmap-Utils/NSE 
    nmap --script-updatedb
    echo -e "\n$greenplus Nmap NSE-scripts successfully installed"

    # ultimate-nmap-parser
    cd $RECON_DIR/Nmap-Utils
    GetTool https://github.com/Shifty0g/ultimate-nmap-parser/
    cd ultimate-nmap-parser/
    chmod +x ultimate-nmap-parser.sh
    echo -e "\n$greenplus ultimate-nmap-parser successfully installed"

    sleep 0.5
    echo -e "\n\n\n\n$greenplus Recon Tools successfully installed"
    echo -e "\n\n"
    tree -d $RECON_DIR -L 1 
    sleep 1
    echo -e "\n\n\n\n"

}


C2-Tools (){

    echo -e "\n$greenplus Downloading & Installing Command & Control Tools"
    C2_DIR=/opt/RedTeam-ToolKit/C2

    # Evil-winrm
    cd $C2_DIR
    GetTool https://github.com/Hackplayers/evil-winrm.git 
    gem install rubyntlm winrm winrm-fs stringio logger fileutils
    echo -e "\n$greenplus Evil-winrm successfully installed"

    # dnscat
    cd $C2_DIR
    GetTool https://github.com/iagox86/dnscat2.git   
    cd dnscat2/server/
    bundle install
    echo -e "\n$greenplus dnscat2 successfully installed"
    
    # Pwncat
    cd $C2_DIR
    echo -e "\n$greenplus Installing Pwncat"
    python3 -m venv /opt/RedTeam-ToolKit/C2/pwncat
    /opt/RedTeam-ToolKit/C2/pwncat/bin/pip install git+https://github.com/calebstewart/pwncat
    ln -s /opt/RedTeam-ToolKit/C2/pwncat/bin/pwncat /usr/local/bin
    echo -e "\n$greenplus Pwncat successfully installed"

    # DeathStar-Empire
    cd $C2_DIR
    echo -e "\n$greenplus Installing DeathStar-Empire"
    echo -e "$greenplus starting to install DeathStar-Empire requirements "
    pip3 install poetry --quiet
    GetTool https://github.com/byt3bl33d3r/DeathStar
    cd DeathStar
    poetry install
    echo -e "\n$greenplus DeathStar-Empire successfully installed"
    

    sleep 0.5
    echo -e "\n\n\n\n$greenplus Command & Control Tools successfully installed"
    echo -e "\n\n"   
    tree -d $C2_DIR -L 1 
    sleep 1
    echo -e "\n\n\n\n"


}


Web-Tools (){
    
    # Web Tools
    echo -e "\n$greenplus Downloading & Installing Web-Tools"
    WEB_DIR=/opt/RedTeam-ToolKit/Web

    
    # Duplicut
    cd /opt/RedTeam-ToolKit/Resources
    GetTool https://github.com/nil0x42/duplicut.git
    cd duplicut/ && make &> /dev/null
    cp duplicut /usr/bin
    echo -e "\n$greenplus duplicut successfully installed"
    
    # OneListForAll
    cd $WEB_DIR
    GetTool https://github.com/six2dez/OneListForAll.git
    cd OneListForAll
    ./olfa.sh
    echo -e "\n$greenplus OneListForAll successfully installed"
    

    # reconftw
    cd $WEB_DIR
    GetTool https://github.com/six2dez/reconftw.git
    cd reconftw
    mkdir ReconFTW-Tools
    replace-line 'tools=/opt/RedTeam-ToolKit/Web/reconftw/ReconFTW-Tools' 6 reconftw.cfg 
    replace-line 'export GOROOT=/usr/lib/go' 15 reconftw.cfg
    #replace-line 'export GOPATH=$HOME/go' 16 reconftw.cfg
    #replace-line 'export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH' 17 reconftw.cfg
    #sed -i -e '15,17s/^/# /' reconftw.cfg
    pip3 install -r requirements.txt --quiet
    ./install.sh
    echo -e "\n$greenplus ReconFTW successfully installed"


    # nuclei-templates
    cd $WEB_DIR
    mkdir /opt/RedTeam-ToolKit/Web/Nuclei-Util
    
    # Nuclei-Templates
    echo -e "\n$greenplus Donwloading  Nuclei-Templates"
    cd $WEB_DIR/Nuclei-Util/
    (GetTool https://github.com/ARPSyndicate/kenzer-templates.git)
    (GetTool https://github.com/panch0r3d/nuclei-templates.git Nuclei-Templates1)
    (GetTool https://github.com/medbsq/ncl.git)
    (GetTool https://github.com/notnotnotveg/nuclei-custom-templates.git)
    (GetTool https://github.com/foulenzer/foulenzer-templates.git)
    (GetTool https://github.com/clarkvoss/Nuclei-Templates.git Nuclei-Templates2)
    (GetTool https://github.com/z3bd/nuclei-templates.git Nuclei-Templates3)
    echo -e "\n$greenplus Nuclei-Templates successfully installed"
    
    # 4-ZERO-3
    cd $WEB_DIR
    GetTool https://github.com/Dheerajmadhukar/4-ZERO-3.git
    echo -e "\n$greenplus 4-ZERO-3 successfully installed"

    sleep 0.5
    echo -e "\n\n\n\n$greenplus Web-Tools successfully installed"
    echo -e "\n\n"
    tree -d $WEB_DIR -L 1 
    sleep 1
    echo -e "\n\n\n\n"
    
    hash -r

}


Wifi-Tools (){
    
    #Wifi Tools
    echo -e "\n$greenplus Downloading & Installing Wifi-Tools"
    WIFI_DIR=/opt/RedTeam-ToolKit/Wifi

    # OWT
    cd $WIFI_DIR
    GetTool https://github.com/clu3bot/OWT.git
    echo -e "\n$greenplus OWT successfully installed"
    
    # airgeddon
    cd $WIFI_DIR
    echo -e "\n$greenplus Installing airgeddon"    
    if ! (git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git) then
        echo -e "$redexclaim Error while donwloading, trying again in 30 seconds";sleep 30;git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git
    else
        echo -e "\n$greenplus airgeddon successfully installed"
    fi
    
    # websploit
    cd $WIFI_DIR
    GetTool https://github.com/websploit/websploit.git
    cd websploit
    python3 setup.py install &> /dev/null
    echo -e "\n$greenplus websploit successfully installed"
    
    # Wifipumpkin3
    cd $WIFI_DIR
    GetTool https://github.com/P0cL4bs/wifipumpkin3.git
    cd wifipumpkin3
    python3 -c "from PyQt5.QtCore import QSettings; print('PyQt5 for wifipumpkin3 ')"
    python3 setup.py install &> /dev/null
    echo -e "\n$greenplus wifipumpkin3 successfully installed"
    
    sleep 0.5
    echo -e "\n\n\n\n$greenplus Wifi-Tools successfully installed"
    echo -e "\n\n"
    tree -d $WIFI_DIR -L 1
    sleep 1
    echo -e "\n\n\n\n"

}


Mobile-Tools (){
    
    # Mobile-Tools
    echo -e "\n$greenplus Downloading & Installing Mobile-Tools"
    MOBILE_DIR=/opt/RedTeam-ToolKit/Mobile

    # MobSF
    cd $MOBILE_DIR
    GetTool https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
    cd Mobile-Security-Framework-MobSF
    docker build -t mobsf . 
    echo 'docker run -it --rm -p 8000:8000 mobsf' >> /usr/bin/mobsf-start
    chmod +x /usr/bin/mobsf-start
    echo -e "\n$greenplus Mobile-Security-Framework-MobSF successfully installed"

    # Phonesploit
    cd $MOBILE_DIR
    GetTool https://github.com/aerosol-can/PhoneSploit.git
    cd PhoneSploit
    echo -e "$greenplus starting to install Phonesploit requirements "
    pip3 install colorama --quiet
    echo -e "\n$greenplus Phonesploit successfully installed"

    # SSL pining
    cd $MOBILE_DIR
    GetTool https://github.com/moxie0/AndroidPinning.git    
    echo -e "\n$greenplus AndroidPinning successfully installed"
    
    sleep 0.5
    echo -e "\n\n\n\n$greenplus Mobile-Tools successfully installed"
    echo -e "\n\n"
    tree -d $MOBILE_DIR -L 1
    sleep 1
    echo -e "\n\n\n\n"

}


Network-Tools () {
    # Networking Tools
    echo -e "\n$greenplus Downloading & Installing Network-Tools"
    NETWORK_DIR=/opt/RedTeam-ToolKit/Network    

    # PCredz
    cd $NETWORK_DIR
    GetTool https://github.com/lgandx/PCredz.git
    echo -e "\n$greenplus PCredz successfully installed"
    
    # mitm6
    cd $NETWORK_DIR
    echo -e "$greenplus starting to install mitm6 requirements "
    pip3 install Cython --quiet && pip3 install python-libpcap --quiet
    GetTool https://github.com/fox-it/mitm6.git
    echo -e "\n$greenplus mitm6 successfully installed"
    
    # Nmap Visulize Network
    cd $NETWORK_DIR
    GetTool https://github.com/tedsluis/nmap.git Nmap_Network-visualization                  
    cd Nmap_Network-visualization
    wget  -q --show-progress -progress=bar:force:noscroll https://gojs.net/latest/release/go.js
    echo -e "\n$greenplus Nmap_Network-visualization successfully installed"    

    # BruteSharkCli
    cd $NETWORK_DIR
    mkdir BruteShark
    cd BruteShark
    echo -e "\n$greenplus Downloading BruteSharkCli\n"
    wget  -q --show-progress -progress=bar:force:noscroll https://github.com/odedshimon/BruteShark/releases/latest/download/BruteSharkCli -O BruteSharkCli
    chmod +x BruteSharkCli 
    echo -e "\n$greenplus BruteSharkCli successfully installed" 
    
    sleep 0.5
    echo -e "\n\n\n\n$greenplus Network-Tools successfully installed"
    echo -e "\n\n"
    tree -d $NETWORK_DIR -L 1
    sleep 1
    echo -e "\n\n\n\n"

}


Tunneling-Tools (){

    echo -e "\n$greenplus Downloading & Installing Tunneling-Tools"
    TUNNLING_DIR=/opt/RedTeam-ToolKit/Tunneling

    # Proxychains
    cd $TUNNLING_DIR
    echo -e "\n$greenplus Installing proxychains-ng "
    GetTool https://github.com/rofl0r/proxychains-ng.git
    cd proxychains-ng
    ./configure --prefix=/usr --sysconfdir=/etc
    make &> /dev/null
    make install-config &> /dev/null
    ln -s $PWD/proxychains4 /usr/bin/proxychains
    replace-line "socks5 127.0.0.1 1080" 159 /etc/proxychains.conf
    echo "# sock4 127.0.0.1 9050" >> /etc/proxychains.conf
    echo -e "\n$greenplus proxychains-ng successfully installed"

    # Chisel
    cd $TUNNLING_DIR
    echo -e "\n$greenplus Installing Chisel"
    mkdir Chisel
    cd $TUNNLING_DIR/Chisel
    wget -q --show-progress --progress=bar:force:noscroll https://github.com/jpillora/chisel/releases/download/v1.7.7/chisel_1.7.7_windows_amd64.gz -O chisel_Windows.gz
    gunzip chisel_Windows.gz &> /dev/null
    mv chisel_Windows chisel.exe 
    wget -q --show-progress --progress=bar:force:noscroll https://github.com/jpillora/chisel/releases/download/v1.7.6/chisel_1.7.7_linux_amd64.gz -O chisel.gz
    gunzip chisel.gz &> /dev/null
    echo -e "\n$greenplus chisel successfully installed"

    # PingTunnel
    cd $TUNNLING_DIR
    echo -e "\n$greenplus Installing pingtunnel"
    mkdir pingtunnel && cd pingtunnel
    wget -q --show-progress --progress=bar:force:noscroll https://github.com/esrrhs/pingtunnel/releases/download/2.6/pingtunnel_windows_amd64.zip -O pingtunnel_windows.zip 
    unzip pingtunnel_windows.zip &> /dev/null
    wget -q --show-progress --progress=bar:force:noscroll https://github.com/esrrhs/pingtunnel/releases/download/2.6/pingtunnel_linux_amd64.zip -O pingtunnel_linux.zip
    unzip pingtunnel_linux.zip &> /dev/null
    rm pingtunnel_linux.zip
    rm pingtunnel_windows.zip
    echo -e "\n$greenplus pingtunnel successfully installed"


    # Ptunnel-ng
    cd $TUNNLING_DIR
    GetTool https://github.com/lnslbrty/ptunnel-ng.git
    cd ptunnel-ng
    wget -q --show-progress --progress=bar:force:noscroll https://github.com/lnslbrty/ptunnel-ng/releases/download/v1.42/ptunnel-ng-x64.exe -O ptunnel-ng.exe
    ./autogen.sh &> /dev/null
    echo -e "\n$greenplus ptunnel-ng successfully installed"

    sleep 0.5
    echo -e "\n\n\n\n$greenplus Tunneling-Tools successfully installed"
    echo -e "\n\n"
    tree -d $TUNNLING_DIR -L 1
    sleep 1
    echo -e "\n\n\n\n"

}


Payloads-Tools (){
    
    echo -e "\n$greenplus Downloading & Installing Payloads-Development Tools"
    PAYLOAD_DEV_DIR=/opt/RedTeam-ToolKit/Payload_Dev
    
    # Invoke-Stealth
    cd $PAYLOAD_DEV_DIR
    GetTool https://github.com/JoelGMSec/Invoke-Stealth.git
    echo -e "\n$greenplus Invoke-Stealth successfully installed"

    # PEozer
    cd $PAYLOAD_DEV_DIR
    GetTool https://github.com/phra/PEzor.git
    cd PEzor
    replace-line '(grep -q _prefix_PEzor_ ~/.zshrc || echo "export PATH=\$PATH:~/go/bin/:$INSTALL_DIR:$INSTALL_DIR/deps/donut/:$INSTALL_DIR/deps/wclang/_prefix_PEzor_/bin/") >> ~/.zshrc &&' 52 install.sh
    ./install.sh
    source $HOME/.zshrc
    ./PEzor.sh -h
    echo -e "\n$greenplus PEzor successfully installed"

    # darkarmour
    cd $PAYLOAD_DEV_DIR
    GetTool https://github.com/bats3c/darkarmour.git
    echo -e "\n$greenplus darkarmour successfully installed"

    # ScareCrow
    cd $PAYLOAD_DEV_DIR
    GetTool https://github.com/optiv/ScareCrow.git
    cd ScareCrow
    go get github.com/fatih/color
    go get github.com/yeka/zip
    go get github.com/josephspurrier/goversioninfo
    apt install openssl osslsigncode mingw-w64 -y
    go build ScareCrow.go
    echo -e "\n$greenplus ScareCrow successfully installed"

    # donloader
    cd $PAYLOAD_DEV_DIR
    GetTool https://github.com/blinkenl1ghts/donloader.git
    cd donloader
    go install mvdan.cc/garble@latest
    GO111MODULE=off go get -u golang.org/x/sys/...
    GOOS=windows GO111MODULE=on go get -u github.com/C-Sto/BananaPhone
    GOOS=windows GO111MODULE=on go get -u github.com/Binject/debug
    GOOS=windows GO111MODULE=off go get -u github.com/C-Sto/BananaPhone
    GOOS=windows GO111MODULE=off go get -u github.com/Binject/debug
    GO111MODULE=off go get -u github.com/awgh/rawreader
    go build -o "bin/donloader" .
    echo -e "\n$greenplus donloader successfully installed"

    # Chimera
    cd $PAYLOAD_DEV_DIR
    GetTool https://github.com/tokyoneon/Chimera.git
    echo -e "\n$greenplus Chimera successfully installed"
    
    # Phantom-Evasion
    cd $PAYLOAD_DEV_DIR
    GetTool https://github.com/oddcod3/Phantom-Evasion.git
    cd Phantom-Evasion
    chmod +x phantom-evasion.py
    python3 phantom-evasion.py --setup
    echo -e "\n$greenplus Phantom-Evasion successfully installed"

    # NimHollow

    cd $PAYLOAD_DEV_DIR
    echo -e "\n$greenplus Installing NimHollow"
    git clone --recurse-submodules https://github.com/snovvcrash/NimHollow && cd NimHollow
    git submodule update --init --recursive
    nimble install winim nimcrypto
    pip3 install -r requirements.txt --quiet
    echo -e "\n$greenplus NimHollow successfully installed"

    # Shhhloader

    cd $PAYLOAD_DEV_DIR
    echo -e "\n$greenplus Installing Shhhloader"
    GetTool https://github.com/icyguider/Shhhloader
    echo -e "\n$greenplus Shhhloader successfully installed"
    
    # Nimcrypt2

    cd $PAYLOAD_DEV_DIR
    echo -e "\n$greenplus Installing Nimcrypt2"
    GetTool https://github.com/icyguider/Nimcrypt2.git
    nimble install docopt ptr_math strenc
    cd Nimcrypt2
    nim c -d=release --cc:gcc --embedsrc=on --hints=on --app=console --cpu=amd64 --out=nimcrypt nimcrypt.nim
    echo -e "\n$greenplus Nimcrypt2 successfully installed"
    
    sleep 0.5
    echo -e "\n\n\n\n$greenplus Payloads-Development Tools successfully installed"
    echo -e "\n\n"
    tree -d $PAYLOAD_DEV_DIR -L 1
    sleep 1
    echo -e "\n\n\n\n"

}


Phishing-Tools () {
    echo -e "\n$greenplus Downloading & Installing Phishing-Tools"
    PHISHING_DIR=/opt/RedTeam-ToolKit/Initial_Access/Phishing

    # phishmonger
    cd $PHISHING_DIR
    GetTool https://github.com/fkasler/phishmonger.git
    echo -e "\n$greenplus phishmonger successfully installed"

    # gophish
    cd $PHISHING_DIR
    GetTool https://github.com/gophish/gophish.git
    go get github.com/gophish/gophish
    cd gophish
    go build
    echo -e "\n$greenplus gophish successfully installed"

    # Phishing Templates
    echo -e "\n$greenplus Installing Phishing Templates"
    cd $PHISHING_DIR
    mkdir PhishingTemplates

    # phishfactory
    cd $PHISHING_DIR/PhishingTemplates
    GetTool https://github.com/werdox/phishfactory.git
    cd phishfactory
    echo -e "$greenplus starting to install phishfactory requirements "
    pip3 install --no-cache-dir -r requirements.txt --quiet
    python3 install.py
    echo -e "\n$greenplus phishfactory successfully installed"

    cd $PHISHING_DIR/PhishingTemplates
    
    # Gophish_Templates
    GetTool https://github.com/criggs626/PhishingTemplates.git Gophish_PhishingTemplates
    
    # king-phisher-templates
    GetTool https://github.com/rsmusllp/king-phisher-templates.git

    # ZeroPointSecurity_PhishingTemplates
    GetTool https://github.com/ZeroPointSecurity/PhishingTemplates.git ZeroPointSecurity_PhishingTemplates
    
    # Office Phishing Templates
    GetTool https://github.com/MartinSohn/Office-phish-templates.git

    echo -e "\n$greenplus Phishing Templates successfully installed";

    sleep 0.5
    echo -e "\n\n\n\n$greenplus Phishing-Tools successfully installed"
    echo -e "\n\n"
    tree -d $PHISHING_DIR -L 1 
    sleep 1
    echo -e "\n\n\n\n"

}


BruteForce-Tools () {

    echo -e "\n$greenplus Downloading & Installing BruteForce,PasswordSpray Tools"
    BRUTEFORCE_DIR=/opt/RedTeam-ToolKit/Initial_Access/BruteForce

    # brutespray
    cd $BRUTEFORCE_DIR
    GetTool https://github.com/x90skysn3k/brutespray.git
    cd brutespray
    echo -e "$greenplus starting to install brutespray requirements "
    pip3 install --no-cache-dir -r requirements.txt --quiet
    echo -e "\n$greenplus brutespray successfully installed"

    # msspray
    cd $BRUTEFORCE_DIR
    GetTool https://github.com/SecurityRiskAdvisors/msspray.git
    echo -e "\n$greenplus msspray successfully installed";

    # SprayingToolkit
    cd $BRUTEFORCE_DIR
    GetTool https://github.com/byt3bl33d3r/SprayingToolkit.git
    echo -e "$greenplus starting to install SprayingToolkit requirements "
    cd SprayingToolkit
    pip3 install --no-cache-dir -r requirements.txt --quiet
    echo -e "\n$greenplus SprayingToolkit successfully installed"

    # Omnispray
    cd $BRUTEFORCE_DIR
    GetTool https://github.com/0xZDH/Omnispray.git
    cd Omnispray
    echo -e "$greenplus starting to install Omnispray requirements "
    pip3 install --no-cache-dir -r requirements.txt --quiet
    echo -e "\n$greenplus Omnispray successfully installed"

    # kerbute
    cd $BRUTEFORCE_DIR
    GetTool https://github.com/ropnop/kerbrute.git
    cd kerbrute
    make linux
    make windows
    mv dist/kerbrute_windows_amd64.exe dist/kerbrute.exe
    mv dist/kerbrute_linux_amd64 dist/kerbrute
    rm dist/kerbrute_*
    ln -s /opt/RedTeam-ToolKit/Initial_Access/BruteForce/kerbrute/dist/kerbrute /usr/bin/kerbrute
    echo -e "\n$greenplus kerbrute successfully installed"    

    sleep 0.5
    echo -e "\n\n\n\n$greenplus BruteForce,PasswordSpray Tools successfully installed"
    echo -e "\n\n"
    tree -d $BRUTEFORCE_DIR -L 1 
    sleep 1
    echo -e "\n\n\n\n"


}


ActiveDirectory_Enumeration-Tools () {

    echo -e "\n$greenplus Downloading & Installing Active-Directory Enumeration Tools"
    AD_ENUM_DIR=/opt/RedTeam-ToolKit/Active_Directory/Enumeration

    # Enum4linux-ng
    cd $AD_ENUM_DIR
    echo -e "\n$greenplus Installing Enum4linux-ng"
    GetTool https://github.com/cddmp/enum4linux-ng
    cd enum4linux-ng
    python3 -m venv enum4linux-ng-env
    source enum4linux-ng-env/bin/activate
    echo -e "$greenplus starting to install enum4linux-ng requirements "
    pip3 install wheel --quiet
    pip3 install --no-cache-dir -r requirements.txt --quiet
    echo -e "\n$greenplus Enum4linux-ng successfully installed"
    
    # Pretty ldapdomaindump output
    cd $AD_ENUM_DIR
    echo -e "\n$greenplus Downloading prettyloot.py"
    wget -q --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/mpgn/ntlmrelayx-prettyloot/master/ntlmrelayx-prettyloot.py -O prettyloot.py
    echo -e "\n$greenplus prettyloot.py successfully installed"

    # BloodHound
    cd $AD_ENUM_DIR
    echo "deb http://httpredir.debian.org/debian stretch-backports main" | tee -a /etc/apt/sources.list.d/stretch-backports.list
    apt update
    apt install neo4j -y
    wget -q --show-progress --progress=bar:force:noscroll https://github.com/BloodHoundAD/BloodHound/releases/download/4.2.0/BloodHound-linux-x64.zip
    unzip BloodHound-linux-x64.zip
    mv BloodHound-linux-x64 BloodHound
    rm BloodHound-linux-x64.zip
    chmod +x BloodHound/BloodHound
    ln -s /opt/RedTeam-ToolKit/Active_Directory/Enumeration/BloodHound/BloodHound /usr/bin/bloodhound
    echo -e "\n$greenplus Bloodhound successfully installed"

    _popd() {
    popd 2>&1 > /dev/null
    }

    echo -e "\n$greenplus Installing BloodHound Utils"
    mkdir /opt/RedTeam-ToolKit/Active_Directory/Enumeration/BloodHound-Util

    downloadRawFile "https://github.com/ShutdownRepo/Exegol/raw/master/sources/bloodhound/customqueries.json" /tmp/customqueries1.json
    downloadRawFile "https://github.com/CompassSecurity/BloodHoundQueries/raw/master/customqueries.json" /tmp/customqueries2.json
    downloadRawFile "https://github.com/ZephrFish/Bloodhound-CustomQueries/raw/main/customqueries.json" /tmp/customqueries3.json
    downloadRawFile "https://github.com/ly4k/Certipy/raw/main/customqueries.json" /tmp/customqueries4.json

    python3 - << 'EOT'
import json
from pathlib import Path
merged, dups = {'queries': []}, set()
for jf in sorted((Path('/tmp')).glob('customqueries*.json')):
    with open(jf, 'r') as f:
        for query in json.load(f)['queries']:
            if 'queryList' in query.keys():
                qt = tuple(q['query'] for q in query['queryList'])
                if qt not in dups:
                    merged['queries'].append(query)
                    dups.add(qt)
with open(Path.home() / '.config' / 'bloodhound' / 'customqueries.json', 'w') as f:
    json.dump(merged, f, indent=4)
EOT
    rm /tmp/customqueries*.json

    downloadRawFile "https://github.com/ShutdownRepo/Exegol/raw/master/sources/bloodhound/config.json" ~/.config/bloodhound/config.json
    sed -i 's/"password": "exegol4thewin"/"password": "bloodhound"/g' ~/.config/bloodhound/config.json

    _popd


    # AzureHound
    cd $AD_ENUM_DIR/BloodHound-Util
    GetTool https://github.com/BloodHoundAD/AzureHound.git 
    echo -e "\n$greenplus AzureHound successfully installed"

    # BloodHound.py
    cd $AD_ENUM_DIR/BloodHound-Util
    GetTool https://github.com/fox-it/BloodHound.py.git BloodHound-Python
    cd BloodHound-Python 
    python setup.py install 
    echo -e "\n$greenplus BloodHound.py successfully installed"

    # bloodhound-quickwin 
    cd $AD_ENUM_DIR/BloodHound-Util  
    GetTool https://github.com/kaluche/bloodhound-quickwin.git  
    echo -e "\n$greenplus bloodhound-quickwin successfully installed"
    
    # cypheroth
    cd $AD_ENUM_DIR/BloodHound-Util  
    GetTool https://github.com/seajaysec/cypheroth.git
    echo -e "$greenplus starting to install cypheroth requirements "
    pip3 install py2neo --quiet
    pip3 install pandas --quiet
    pip3 install prettytable --quiet  
    echo -e "\n$greenplus cypheroth successfully installed"

    # SpinUp-BloodHound
    cd $AD_ENUM_DIR/BloodHound-Util
    echo -e "$greenplus Downloading SpinUp-BloodHound successfully installed"
    wget -q --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/theGuildHall/pwnbox/master/bloodhound/startBH.sh -O SpinUp-BloodHound.sh
    replace-line "   bloodhound --no-sandbox" 7 SpinUp-BloodHound.sh
    replace-line "   bloodhound --no-sandbox" 10 SpinUp-BloodHound.sh
    chmod +x SpinUp-BloodHound.sh 
    echo -e "\n$greenplus SpinUp-BloodHound successfully installed"
    
    # ItWasAllADream
    cd $AD_ENUM_DIR
    GetTool https://github.com/byt3bl33d3r/ItWasAllADream.git
    cd ItWasAllADream && poetry install
    touch start-env.sh
    echo -e '#!/bin/zsh \npoetry shell' > start-env.sh;chmod +x start-env.sh
    echo -e "\n$greenplus ItWasAllADream successfully installed"

    sleep 0.5
    echo -e "\n\n\n\n$greenplus Active-Directory Enumeration Tools successfully installed"
    echo -e "\n\n"
    tree -d $AD_ENUM_DIR -L 1 
    sleep 1
    echo -e "\n\n\n\n"

}


ActiveDirectory_CredentialDumping-Tools () {

    echo -e "\n$greenplus Downloading & Installing Active-Directory Credential Dumping Tools"
    AD_CREDS_DUMP_DIR=/opt/RedTeam-ToolKit/Active_Directory/Credential_Dumping
    
    #pypykatz
    cd $AD_CREDS_DUMP_DIR
    GetTool https://github.com/skelsec/pypykatz.git 
    echo -e "$greenplus starting to install pypykatz requirements "
    pip3 install minidump minikerberos aiowinreg msldap winacl --quiet
    cd pypykatz
    python3 setup.py install &> /dev/null
    echo -e "\n$greenplus pypykatz successfully installed"

    # spraykatz
    cd $AD_CREDS_DUMP_DIR
    GetTool https://github.com/aas-n/spraykatz.git
    cd spraykatz
    echo -e "$greenplus starting to install spraykatz requirements "
    pip3 install --no-cache-dir -r requirements.txt --quiet
    echo -e "\n$greenplus spraykatz successfully installed"

    #lsassy
    cd $AD_CREDS_DUMP_DIR
    echo -e "$greenplus starting to install lsassy "
    python3 -m pip uninstall lsassy --quiet
    python3 -m pip install lsassy --quiet
    echo -e "\n$greenplus lsassy successfully installed"

    # nanodump
    cd $AD_CREDS_DUMP_DIR
    GetTool https://github.com/helpsystems/nanodump.git
    cp -r nanodump nanodump_Opsec
    cd nanodump_Opsec
    rm -f compiled/*.*
    make
    echo -e "\n$greenplus nanodump successfully installed"

    sleep 0.5
    echo -e "\n\n\n\n$greenplus Active-Directory Credential Dumping Tools successfully installed"
    echo -e "\n\n"
    tree -d $AD_CREDS_DUMP_DIR -L 1 
    sleep 1
    echo -e "\n\n\n\n"

}


ActiveDirectory_Offensive-Tools (){

    echo -e "\n$greenplus Downloading & Installing Active-Directory Offensive-Tools "
    AD_OFFENSIVE_TOOLS_DIR=/opt/RedTeam-ToolKit/Active_Directory/Offensive-Tools
    
    # impcaket
    cd $AD_OFFENSIVE_TOOLS_DIR
    GetTool https://github.com/SecureAuthCorp/impacket.git
    cd impacket
    python3 -m venv impacket-env 
    source impacket-env/bin/activate
    python3 setup.py install &> /dev/null
    deactivate
    echo -e "\n$greenplus impacket successfully installed"

    # Zerologon
    cd $AD_OFFENSIVE_TOOLS_DIR
    mkdir Zerologon
    echo -e "\n$greenplus Installing All CVE-2020-1472 aka Zerologon Tools AND Utils "
    cd Zerologon
    
    # ADZero
    GetTool https://github.com/Privia-Security/ADZero.git
    echo -e "\n$greenplus ADZero successfully installed"

    # CVE-2020-1472
    GetTool https://github.com/dirkjanm/CVE-2020-1472.git     
    echo -e "\n$greenplus CVE-2020-1472 successfully installed"
    
    # 0-logon
    GetTool https://github.com/sho-luv/zerologon.git 0-logon
    echo -e "\n$greenplus 0-logon successfully installed"

    echo -e "\n$greenplus Downloading Zerologon_Checker"
    wget -q --show-progress --progress=bar:force:noscroll "https://raw.githubusercontent.com/SecuraBV/CVE-2020-1472/master/zerologon_tester.py" -O Zerologon_Checker.py
    echo -e "\n$greenplus Zerologon_Checker successfully installed"

    # PrintNightmare
    echo -e "\n$greenplus Installing All CVE-2021-1675 aka PrintNightmare Tools AND Utils "
    cd $AD_OFFENSIVE_TOOLS_DIR
    mkdir PrintNightmare
    cd PrintNightmare
    python3 -m venv PrintNightmare-env
    source PrintNightmare-env/bin/activate

    # cube0x0 CVE-2021-1675
    GetTool https://github.com/cube0x0/CVE-2021-1675.git
    cd CVE-2021-1675
    echo -e "\n$greenplus Downloading threaded_CVE-2021-1675"
    wget -q --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/SleepiPanda/CVE-2021-1675/bce1f74677c653ea8fc4babf96b7a55ec8f77be2/threaded_CVE-2021-1675.py -O threaded_CVE-2021-1675.py 
    echo -e "\n$greenplus CVE-2021-1675 successfully installed"


    # cube0x0 impacket for printnightmare
    cd $AD_OFFENSIVE_TOOLS_DIR/PrintNightmare
    GetTool https://github.com/cube0x0/impacket.git cube0x0_impacket
    cd cube0x0_impacket
    python3 ./setup.py install &> /dev/null
    deactivate
    echo -e "\n$greenplus cube0x0-impacket successfully installed"

    #  PrintNightmare-py
    cd $AD_OFFENSIVE_TOOLS_DIR/PrintNightmare
    GetTool https://github.com/ollypwn/PrintNightmare.git PrintNightmare-py
    echo -e "\n$greenplus PrintNightmare-py successfully installed"

    # PetitPotam
    cd $AD_OFFENSIVE_TOOLS_DIR
    GetTool https://github.com/topotam/PetitPotam.git
    cd PetitPotam
    GetTool https://github.com/ollypwn/PetitPotam.git PetitPotam-py
    echo -e "\n$greenplus PetitPotam successfully installed"


    # kdc bamboozling
    cd $AD_OFFENSIVE_TOOLS_DIR
    echo -e "\n$greenplus Installing All CVE-2021-42278 aka KDC Bamboozling Tools AND Utils "
    mkdir KDC_Bamboozling
    
    # Pachine
    cd $AD_OFFENSIVE_TOOLS_DIR/KDC_Bamboozling
    GetTool https://github.com/ly4k/Pachine.git
    echo -e "\n$greenplus Pachine successfully installed"

    # sam the admin
    cd $AD_OFFENSIVE_TOOLS_DIR/KDC_Bamboozling
    GetTool https://github.com/WazeHell/sam-the-admin
    echo -e "\n$greenplus sam-the-admin successfully installed"

    #noPAC
    cd $AD_OFFENSIVE_TOOLS_DIR/KDC_Bamboozling
    GetTool https://github.com/Ridter/noPac.git noPac-PY
    echo -e "\n$greenplus noPac-PY successfully installed"



    # Windows Binary, powershell scripts, and exploits
    cd /opt/RedTeam-ToolKit/Active_Directory
    GetTool https://github.com/BlackSnufkin/PT-ToolKit.git
    mv PT-ToolKit/Windows-Binary /opt/RedTeam-ToolKit/Active_Directory/Offensive-Tools
    mv PT-ToolKit/PowerShell-Scripts /opt/RedTeam-ToolKit/Active_Directory/Offensive-Tools
    mv PT-ToolKit/Exploits /opt/RedTeam-ToolKit
    rm -rf PT-ToolKit 
    echo -e "\n$greenplus Windows Binary, powershell scripts, and exploits successfully installed"

    sleep 0.5
    echo -e "\n\n\n\n$greenplus Active-Directory Offensive-Tools successfully installed"
    echo -e "\n\n"
    tree -d $AD_OFFENSIVE_TOOLS_DIR -L 2
    sleep 1
    echo -e "\n\n\n\n"

}

Exploits () {

    echo -e "\n$greenplus Downloading & Installing Exploits"
    LOG4J_DIR=/opt/RedTeam-ToolKit/Exploits/Log4Shell

    # Log4J
    echo -e "\n$greenplus Installing Log4J aka Log4Shell Tools and utils"
    mkdir /opt/RedTeam-ToolKit/Exploits/Log4Shell
    cd $LOG4J_DIR
    python3 -m venv log4j-venv
    source log4j-venv/bin/activate
    
    #log4j scanner
    GetTool https://github.com/fullhunt/log4j-scan.git
    cd log4j-scan
    pip3 install --no-cache-dir -r requirements.txt --quiet
    
    # log4j RCE
    cd $LOG4J_DIR
    GetTool https://github.com/cyberstruggle/L4sh.git
    cd L4sh
    pip3 install --no-cache-dir -r requirements.txt --quiet

    # JNDI-Exploit-Ki
    cd $LOG4J_DIR 
    GetTool https://github.com/pimps/JNDI-Exploit-Kit.git

    # log4rce
    cd $LOG4J_DIR
    GetTool https://github.com/alexandre-lavoie/python-log4rce.git
    deactivate
    echo -e "\n$greenplus Log4J aka Log4Shell Tools and utils successfully installed"

    sleep 0.5
    echo -e "\n\n\n\n$greenplus Exploits successfully installed"
    echo -e "\n\n"
    tree -d /opt/RedTeam-ToolKit/Exploits -L 2 
    sleep 1
    echo -e "\n\n\n\n"

}




Twiking () {

    echo -e "\n$greenplus Installing & Fixing some Stuff"
    
    # Stabilize Shell
    cd /opt/RedTeam-ToolKit/Resources
    GetTool https://github.com/JohnHammond/poor-mans-pentest.git
    cd poor-mans-pentest
    replace-line '    xte "key F12"' 15 functions.sh
    replace-line 'call_cmd "/usr/bin/script -qc /bin/bash /dev/null"' 6 stabilize_zsh_shell.sh
    replace-line 'source "/opt/RedTeam-ToolKit/Resources/poor-mans-pentest/functions.sh"' 3 stabilize_zsh_shell.sh
    echo 'call_cmd "exec clear"' >> stabilize_zsh_shell.sh
    ln -s /opt/RedTeam-ToolKit/Resources/poor-mans-pentest/stabilize_zsh_shell.sh /usr/bin/stabilize_shell
    echo -e "\n$greenplus poor-mans-pentest successfully installed"

    # bat
    cd $HOME
    echo -e "\n$greenplus Installing bat"
    cargo install --locked bat
    ln -s /root/.cargo/bin/bat /usr/bin/bat
    bat --generate-config-file
    echo '--pager="cat"' >  /root/.config/bat/config
    echo -e "\n$greenplus BAT successfully installed" 

    # pimpmykali
    cd /opt/RedTeam-ToolKit/Resources
    GetTool https://github.com/Dewalt-arch/pimpmykali.git
    cd pimpmykali
    ./pimpmykali.sh --missing; \
    ./pimpmykali.sh --smb; \
    ./pimpmykali.sh --grub; \
    ./pimpmykali.sh --flameshot; \
    echo -e "\n$greenplus pimpmykali successfully installed\n"
    
    #replace-line "autologin-user=root" 126 /etc/lightdm/lightdm.conf
    #replace-line "autologin-user-timeout=" 127 /etc/lightdm/lightdm.conf
    echo -e "\n$greenplus Running updatedb...\n"
    updatedb
    msfdb init
    sleep 0.5
    echo -e "\n$greenplus Done doing Twiking to the system\n"
    sleep 0.5
}


if [ "$EUID" -ne 0 ]
    then echo -e "$redexclaim This Script must be run with sudo"
    exit
fi

apt -qq list kali-root-login | grep 'installed' &> /dev/null
if [ $? == 0 ]; then
    
    disable_power_checkde

    systemctl enable snapd.service
    service snapd start
    systemctl enable docker
    systemctl enable postgresql
    
    SpinUp_Workspace
    Recon-Tools
    C2-Tools
    Wifi-Tools
    Phishing-Tools
    #Mobile-Tools
    Network-Tools 
    Tunneling-Tools
    Payloads-Tools 
    BruteForce-Tools
    ActiveDirectory_Enumeration-Tools
    ActiveDirectory_CredentialDumping-Tools
    ActiveDirectory_Offensive-Tools
    Exploits
    Web-Tools
    Utils-Tools
    Twiking
    echo -e "\n\n\n\n$greenplus Done! All tools are set up in /opt/RedTeam-ToolKit"
    echo -e "\n\n"

    tree -d $RECON_DIR -L 1
    echo -e "\n\n"
    
    tree -d $C2_DIR -L 1
    echo -e "\n\n"
    
    tree -d $WEB_DIR -L 1
    echo -e "\n\n"

    tree -d $WIFI_DIR -L 1
    echo -e "\n\n"

    #tree -d $MOBILE_DIR -L 1
    #echo -e "\n\n"

    tree -d $NETWORK_DIR -L 1
    echo -e "\n\n"

    tree -d $TUNNLING_DIR -L 1
    echo -e "\n\n"

    tree -d $PAYLOAD_DEV_DIR -L 1
    echo -e "\n\n"

    tree -d /opt/RedTeam-ToolKit/Initial_Access -L 2
    echo -e "\n\n"

    tree -d /opt/RedTeam-ToolKit/Active_Directory -L 2
    echo -e "\n\n"

    tree -d /opt/RedTeam-ToolKit/Exploits -L 2    
    echo -e "\n\n"

    echo -e "$greenplus Press ENTER key to Continue..."
    answer=x
    until [ -z "$answer" ]; do
    read answer
    done

    Update && apt reinstall python3-debian -y && check_reboot

    echo -e "\n$redexclaim Rebooting in 20 seconds...";
    sleep 20
    reboot;
 

else
    systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target;
    disable_power_checkde
    Update_and_install 
    echo -e "\n$redexclaim Rebooting in 20 seconds...";
    sleep 20
    reboot;
    
fi
set +x
