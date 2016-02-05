#!/bin/bash
# Sega was here!!!
#

# ------------------------------------------------------------------------------
#
# Initialization file
# -------------------
# The following is done here:
# - OS detection, value is written to _bf_ostype
# - Sourcing of all the needed dirs/files in the correct order:
# - Load start screen /lib/start_screen.sh
# - Unset unneeded variables
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Source dir/files according to pattern
# Usage: _source_files, declare $files outside function, passing over
# 		 to function does not work since it will be treated as string literal
# ------------------------------------------------------------------------------
_source_files()
{
	for file in $files; do
		source $file
		# Debug only: printf $file$'\n'
	done
	unset file
}


# ------------------------------------------------------------------------------


# 1. Load /lib/pre_base*.sh files
files=~/.bash_files/lib/pre_base*.sh; _source_files

# 2. Load config files
files=~/.bash_files/config/*config.sh; _source_files

# 3. Load base files
files=~/.bash_files/lib/base*.sh; _source_files


# ------------------------------------------------------------------------------


_bf_detect_os_type
_bf_get_hostname
_bf_get_ext_ip


# ------------------------------------------------------------------------------


# Load alias files
files=~/.bash_files/aliases/*aliases.sh; _source_files


# Load Start screen
files=~/.bash_files/lib/start_screen.sh; _source_files


# ------------------------------------------------------------------------------

# Cleanup variables
#
_unset_config_vars
unset files
