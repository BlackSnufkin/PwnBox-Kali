# see /usr/share/doc/zsh/examples/zshrc for examples

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt ksharrays           # arrays start at 0
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
export PROMPT_EOL_MARK=""

#Setup path
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:~/.local/bin:/snap/bin:/opt/RedTeam-ToolKit/Payload_Dev/PEzor:$PATH

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[C' forward-word                       # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[D' backward-word                      # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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
    PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)──}(%B%F{%(#.red.blue)}%n%(#.💀.㉿)%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
    RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ "$color_prompt" = yes ]; then
	# ksharrays breaks the plugin. This is fixed now but let's disable it in the
	# meantime.
	# https://github.com/zsh-users/zsh-syntax-highlighting/pull/689
	unsetopt ksharrays
	. /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
	ZSH_HIGHLIGHT_STYLES[default]=none
	ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
	ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
	ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
	ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
	ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
	ZSH_HIGHLIGHT_STYLES[path]=underline
	ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
	ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
	ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[command-substitution]=none
	ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[process-substitution]=none
	ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[assign]=none
	ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
	ZSH_HIGHLIGHT_STYLES[named-fd]=none
	ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
	ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
	ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
	ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    TERM_TITLE='\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a'
    ;;
*)
    ;;
esac

new_line_before_prompt=yes
precmd() {
    # Print the previously configured title
    print -Pn "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$new_line_before_prompt" = yes ]; then
	if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
	    _NEW_LINE_BEFORE_PROMPT=1
	else
	    print ""
	fi
    fi
}


# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
    
    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias em='emacs -nw'
alias dd='dd status=progress'
alias _='sudo'
alias _i='sudo -i'
alias please='sudo'
alias fucking='sudo'
alias chuck_norris_says='sudo'


check_reboot () {
	if [ -f /var/run/reboot-required ];then
		echo  -e '[!] Reboot required \n[!] Rebooting in 5 Seconds';sleep 5;reboot -f
	else
		echo  -e ' \n[+] No reboot required'
		true
	fi
}

Update-RedTeam-ToolKit (){

	cd /opt/RedTeam-ToolKit
	find . -type d -name .git -exec sh -c "cd \"{}\"/../&& sleep 1; echo  && pwd &&  git pull" \;
}

cl() { cd "$@" && ls; }

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

		ping -c1 "8.8.8.8" &>"/dev/null"

		if [[ "${?}" -ne 0 ]]; then
		    echo "NO"
		elif [[ "${#args[@]}" -eq 0 ]]; then
		    echo "YES"
		fi


	else
	    echo "Disconnected"
	fi
}


gc () {

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



alias chrome='google-chrome-stable %u'
alias update='apt update && apt full-upgrade -y && apt autoremove -y && check_reboot'
alias full-update='apt update && apt full-upgrade -y && apt autoremove -y && Update-RedTeam-ToolKit && check_reboot'
alias enum4linux-ng='python3 /opt/RedTeam-ToolKit/Active_Directory/Enumeration/enum4linux-ng/enum4linux-ng.py'
alias rustscan='/opt/RedTeam-ToolKit/Recon/RustScan/target/release/rustscan -a'    
alias evil-winrm='ruby /opt/RedTeam-ToolKit/C2/evil-winrm/evil-winrm.rb'   
alias evil-winrm='ruby /opt/RedTeam-ToolKit/C2/evil-winrm/evil-winrm.rb'
alias c='clear'   
alias off='shutdown -h now'
alias rr='reboot'
alias del='rm -rf "@$"'
alias bc='bat'
alias ch='chmod +x @1'
alias fix-vm='apt reinstall open-vm-tools-desktop open-vm-tools fuse && reboot'
alias fix-loginscreen='cp /root/Pictures/loginscreen.png /usr/share/desktop-base/kali-theme/login/background'
alias set-python2='ln -sfn /usr/bin/python2 /usr/bin/python'
alias set-python3='ln -sfn /usr/bin/python3 /usr/bin/python'   
alias bloodhound-up='/opt/RedTeam-ToolKit/Active_Directory/Enumeration/BloodHound-Util/SpinUp-BloodHound.sh'
alias impacket-env='source /opt/RedTeam-ToolKit/Active_Directory/Offensive-Tools/impacket/impacket-env/bin/activate'
alias PrintNightmare-env='source /opt/RedTeam-ToolKit/Active_Directory/Offensive-Tools/PrintNightmare/PrintNightmare-env/bin/activate'
alias log4j-venv='source /opt/RedTeam-ToolKit/Exploits/Log4Shell/log4j-venv/bin/activate'
alias fuck='sudo $(history -p !!)'
alias nmap-VulScan="nmap --script vulscan/scipag_vulscan/vulscan.nse --script-args=vulscanoutput='ID: {id} - Title: {title} ({matches})\n' --script-args=vulscan/vulscandb=exploitdb.csv -sV -sC -O -p- -f "
alias nmap-Vulners='nmap -sV --script vulners --script-args mincvss=5.0 -O -p- -f '
alias web-srv='python3 -m http.server 8888'
alias Fix-Wifi='service NetworkManager start;airmon-ng stop wlan0mon'
alias obsidian='/usr/share/obsidian/Obsidian.AppImage --no-sandbox'
alias Pcredz='python3 /opt/RedTeam-ToolKit/Network/PCredz/Pcredz'

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi
