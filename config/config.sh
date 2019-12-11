#!/bin/bash


# Config section 1 = show otherwise leave empty


_set_local_scriptname "$BASH_SOURCE"


# Welcome screen info sections
_bf_show_hostname="1"
_bf_show_kernel="1"
_bf_show_distro=""
_bf_show_ext_ip="1"
_bf_show_ssh_status=""
_bf_show_diskstats=""
_bf_show_cpuram="1"
_bf_show_lastlogins=""
_bf_show_aliases=""
_bf_show_random_cmdinfo=""
_bf_show_fortune=""


# Start screen bling bling
_bf_figlet_on="1"
_bf_lolcat_on="1"


# Prompt config
_bf_prompt_reboot_info="0"



_unset_config_vars()
{
	unset _bf_show_hostname
	unset _bf_show_kernel
	unset _bf_show_distro
	unset _bf_show_ext_ip
	unset _bf_show_ssh_status
	unset _bf_show_cpuram
	unset _bf_show_diskstats
	unset _bf_show_lastlogins
	unset _bf_show_aliases
	unset _bf_show_random_cmdinfo

	unset _bf_figlet_on
	unset _bf_lolcat_on

	#unset bf_prompt_reboot_info
}
