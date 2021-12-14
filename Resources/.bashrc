# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:~/.local/bin:/snap/bin:$PATH

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1="\[\033[1;32m\]\342\224\214\342\224\200$([[ $(/opt/Customize-Kali/htb/vpnbash.sh) == *"10."* ]] && echo "[\[\033[1;34m\]$(/opt/Customize-Kali/htb/vpnserver.sh)\[\033[1;32m\]]\342\224\200[\[\033[1;37m\]$(/opt/Customize-Kali/htb/vpnbash.sh)\[\033[1;32m\]]\342\224\200")[\[\033[1;37m\]\u\[\033[01;32m\]@\[\033[01;34m\]\h\[\033[1;32m\]]\342\224\200[\[\033[1;37m\]\w\[\033[1;32m\]]\n\[\033[1;32m\]\342\224\224\342\224\200\342\224\200\342\225\274 [\[\e[01;33m\]??\[\e[01;32m\]]\\$ \[\e[0m\]"
else
    PS1='┌──[\u@\h]─[\w]\n└──╼ \$ '
fi

# Set 'man' colors
if [ "$color_prompt" = yes ]; then
    man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
    }
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\033[1;32m\]\342\224\200\$([[ \$(/opt/pwnbox/vpnbash.sh) == *\"10.\"* ]] && echo \"[\[\033[1;34m\]\$(/opt/pwnbox/vpnserver.sh)\[\033[1;32m\]]\342\224\200[\[\033[1;37m\]\$(/opt/pwnbox/vpnbash.sh)\[\033[1;32m\]]\342\224\200\")[\[\033[1;37m\]\u\[\033[01;32m\]@\[\033[01;34m\]\h\[\033[1;32m\]]\342\224\200[\[\033[1;37m\]\w\[\033[1;32m\]]\\$\[\e[0m\] "
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -lh'
alias la='ls -lha'
alias l='ls -CF'
alias em='emacs -nw'
alias dd='dd status=progress'
alias _='sudo'
alias _i='sudo -i'
alias please='sudo'
alias fucking='sudo'
alias chuck_norris_says='sudo'
alias ip='ip --color=auto'


check_reboot () {
    if [ -f /var/run/reboot-required ];then
        echo  -e '[!] Reboot required \n[!] Rebooting in 5 Seconds';sleep 5;reboot -f
    else
        echo  -e ' \n[+] No reboot required'
        true
    fi
}

Update-Tools (){

    cd /opt/Red-Team-Toolkit
    find . -type d -name .git -exec sh -c "cd \"{}\"/../&& sleep 1; echo  && pwd &&  git pull" \;
}

cl() { cd "$@" && ls -la; }

i() {
netdevice=$(ip r | grep default | awk '/default/ {print $5}')
ip=$(ip addr | grep $netdevice | grep inet | grep 1* | tr -s " " | cut -d " " -f 3 | cut -d "/" -f 1)
if ! [[ $ip == *"169."* ]];then
    gwip=$(ip route | grep eth0 | grep via | cut -d " " -f 3)
    ping=$(ping -c 1 $gwip -W 1 | sed '$!d;s|.*/\([0-9.]*\)/.*|\1|' | cut -c1-4)
    netmask=$(ip -o -f inet addr show "$netdevice"| awk '/scope global/{sub(/[^.]+\//,"0/",$4);print $4}')
    DNS_SRV=$(cat /etc/resolv.conf |grep -i '^nameserver'|head -n1|cut -d ' ' -f2)
    echo "Interface: $netdevice: " | lolcat
    echo "  IP: $ip [$ping ms] " | lolcat
    echo "  Subnet: $netmask" | lolcat
    echo "  Default GW: $gwip " | lolcat
    echo "  DNS Server: $DNS_SRV" | lolcat
    echo -n "  Internet via wget: " | lolcat
    
    wget -q --spider https://google.com
    if [ $? -eq 0 ]; then
        echo "YES" | lolcat
    else
        echo -n "NO" | lolcat
    fi
    echo -n "  Internet via Ping: " | lolcat
    ping -q -w 1 -c 1 8.8.8.8 | grep default | cut -d ' ' -f 3 > /dev/null && echo "YES" | lolcat || echo "NO" | lolcat


else
    echo "Disconnected"
fi
}

alias chrome='google-chrome-stable %u'
alias update='apt update && apt full-upgrade -y && apt autoremove -y && check_reboot'
alias enum4linux-ng='python3 /opt/Red-Team-Toolkit/Active_Directory/Enumeration/enum4linux-ng/enum4linux-ng.py'
alias dirsearch='python3 /opt/Red-Team-Toolkit/Web/dirsearch/dirsearch.py'
alias rustscan='/opt/Red-Team-Toolkit/Recon/RustScan/target/release/rustscan -a'    
alias evil-winrm='ruby /opt/Red-Team-Toolkit/C2/evil-winrm/evil-winrm.rb'
alias c='clear'   
alias off='shutdown -h now'
alias rr='reboot'
alias fix-vm='apt reinstall open-vm-tools-desktop open-vm-tools fuse && reboot'
alias fix-loginscreen='cp /root/Pictures/loginscreen.jpg /usr/share/desktop-base/kali-theme/login'
alias set-python2='ln -sfn /usr/bin/python2 /usr/bin/python'
alias set-python3='ln -sfn /usr/bin/python3 /usr/bin/python'   
alias cat='bat'
alias bloodhound-up='/opt/Red-Team-Toolkit/Active_Directory/Enumeration/BloodHound-Util/SpinUp-BloodHound.sh'
alias impacket-env='source /opt/Red-Team-Toolkit/Active_Directory/Offensive-Tools/impacket/impacket-env/bin/activate'
alias PrintNightmare-env='source /opt/Red-Team-Toolkit/Active_Directory/Offensive-Tools/PrintNightmare/PrintNightmare-env/bin/activate'
alias fuck='sudo $(history -p !!)'
alias nmap-VulnScan='nmap --script nmap-vulners/vulners,vulscan/vulscan --script-args vulscandb=exploitdb.csv -sV -sC -O -p-'
alias nmap-miniVulnScan='nmap --script nmap-vulners/vulners -sV -sC -O -p- '
alias web-srv='python3 -m http.server 8888'
alias Fix-Wifi='service NetworkManager start;airmon-ng stop wlan0mon'
alias obsidian='/usr/share/obsidian/Obsidian.AppImage --no-sandbox'
alias Pcredz='/opt/Red-Team-Toolkit/Network/PCredz/Pcredz'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
