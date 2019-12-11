#!/bin/bash
#
# Configure start screen info blocks


_set_local_scriptname "$BASH_SOURCE"


# This function prints the hostname
_print_hostname()
{
    # Spacer
    printf "\n"

    # Check if figlet is available and config var set
    if [[ -x $(which figlet) &&  ! -z "$_bf_figlet_on" ]]; then
        # Check if lolcat is available and config var set
        if [[ -x $(which lolcat) &&  ! -z "$_bf_lolcat_on" ]]; then
            #print hostname with figlets and lolcat coloring
            _print_ascii_art_lolcat "$_bf_hostname"
        else
            #Print hostename with figlets
            _print_ascii_art "$_bf_hostname"
        fi
    else
        # No fancy ASCII art support available
        printf "\n${BOLD}"
        _print_centered_string "$_bf_hostname"
    fi
}


_print_cpuram()
{


    case $_bf_os_type in
    linux)
        if [[ -f /proc/cpuinfo ]]; then
            local cpu=$(grep -m 1 'model name' /proc/cpuinfo | cut -d: -f2 | sed -e 's/^ *//')
            local real_cores="$(grep -m 1 'cpu cores' /proc/cpuinfo | cut -d: -f2 | sed -e 's/^ *//')"
            local virt_cores="$(grep -m 1 'siblings' /proc/cpuinfo | cut -d: -f2 | sed -e 's/^ *//')"

            
        fi
        if [[ -x $(which free) ]]; then
            ram="$(free -m | awk '/^Mem:/{print $2}') MB RAM"
        fi

        local cpuram="$cpu ($virt_cores/$real_cores) - $ram"
        ;;
    osx)
        if [[ -x $(which sysctl) ]]; then
            local cpu=$(sysctl -n machdep.cpu.brand_string)
            local real_cores=$(sysctl -n machdep.cpu.core_count)
            local virt_cores=$(sysctl -n machdep.cpu.thread_count)

            local ram="$(system_profiler SPHardwareDataType | grep Memory | cut -d: -f2 | tr -d [:blank:]) RAM"

            local cpuram="$cpu ($virt_cores/$real_cores) - $ram"
        fi
        ;;
    *)
        local cpuram=
        ;;
    esac

    printf "${ORANGE}"
    _print_centered_string "$cpuram"
    printf "${NORMAL}"

}


_print_kernel()
{
    # Check for uname and retrieve kernel and architecture
    if [[ -x $(which uname) ]]; then
        local SYS_INFO="$(uname -srm)"

        printf "${BETTER_YELLOW}"
        _print_centered_string "$SYS_INFO"
        printf "${NORMAL}"
    fi
}


_print_distro()
{
    if [[ -x $(which lsb_release) ]]; then
        local distributor=$(lsb_release -si) # Ubuntu
        local version=$(lsb_release -sr) # 15.04
        local longname=$(lsb_release -sd) # Ubuntu Vivid Vervet (development branch)

        local distro="$longname"
        # distro+=" $version"

        printf "${CYAN}"
        _print_centered_string "$distro"

    fi
}



_print_ext_ip()
{
    printf "${GREEN}"
    _print_centered_string "External IP: $_bf_ext_ip"
}


_print_ssh_status()
{
    if [[ ! -z $SSH_CLIENT ]]; then
        printf "${GREEN}\n"
        _print_centered_string "==> Connected through SSH: $SSH_CLIENT"
        printf "${NORMAL}\n"
    fi
}


_print_diskstats()
{
    if [[ -x $(which df) ]]; then
        # disk usage, don't show tmpfs, ecryptfs, encfs, bccfs, sfpfs
        local DISK_INFO=$(df -h -x tmpfs -x devtmpfs -x ecryptfs -x fuse.encfs -x bccfs -x afpfs -T)

        printf ${POWDER_BLUE}
        _print_centered_multiline "$DISK_INFO"
        # printf "%s\n" "$DISK_INFO" | boxes -d ada-box -ph8v1

        printf "${NORMAL}\n"
    fi
}


_print_lastlogins()
{
    if [[ -x $(which last) ]]; then
        local LAST_LOGINS=$(last -in 3 -ad)
        #local linecount=$(printf "%s\n" "$LAST_LOGINS" | grep -c '^')

        printf ${GREY}
        _print_centered_multiline "$LAST_LOGINS"

        printf "${NORMAL}\n"
    fi
}


_print_random_cmdinfo()
{
    if [[ -x $(which whatis) ]]; then
        local rnd_cmd_info="${BETTER_GREY}Random command info:${GREY}"$'\n'
        rnd_cmd_info+=$(whatis $(ls /bin | shuf -n 1))

        _print_centered_multiline "$rnd_cmd_info"
        printf "${NORMAL}\n"
    fi
}


_print_reboot_info()
{
    printf "${BETTER_YELLOW}"
    _print_centered_string "Reboot required!"
    printf "\n${NORMAL}"
}


_bf_fortune()
{
    printf "\n\n${BETTER_GREY}"
    fortune
}



# ############################################################################ #
#                                                                              #
# Change order of sections etc. below                                          #
#                                                                              #
# ############################################################################ #

startscreen()
{
    if [ ! -z "$_bf_show_hostname" ]; then
    	_print_hostname
    fi


    if [ ! -z "$_bf_show_cpuram" ]; then
        #__print_line
        _print_cpuram
    fi


    if [ ! -z "$_bf_show_kernel" ]; then
        _print_kernel
    fi


    if [ ! -z "$_bf_show_distro" ]; then
        _print_distro
    fi


    if [ ! -z "$_bf_show_ext_ip" ]; then
        _print_ext_ip
    fi


    if [ ! -z "$_bf_show_ssh_status" ]; then
        _print_ssh_status
    fi


    if [ ! -z "$_bf_show_diskstats" ]; then
    	_print_line
    	_print_diskstats
    fi


    if [ ! -z "$_bf_show_lastlogins" ]; then
    	_print_line
    	_print_lastlogins
    fi


    # if [[ -x $(which figlet) &&  ! -z "$_bf_figlet_on" ]]; then

    # Print aliases, which is in bash_alias.sh for easier maintenance
    if [[ -f ~/.bash_files/bash_aliases.sh && ! -z "$_bf_show_aliases" ]]; then
    	_print_line
    	_print_apt_shortcuts_info
    fi


    if [[ -x $(which whatis) && ! -z "$_bf_show_random_cmdinfo" ]]; then
        _print_line
        _print_random_cmdinfo
    fi


    if [ -e /var/run/reboot-required ]; then
        _print_line
        _print_reboot_info
    fi


    if [[ -x $(which fortune) && ! -z "$_bf_show_fortune" ]]; then
        _bf_fortune
    fi
}


clear
startscreen
