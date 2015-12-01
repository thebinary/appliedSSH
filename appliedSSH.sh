#!/bin/bash

#Author	    :	thebinary <binary4bytes@gmail.com>
#Date	    :	Tue Dec 01 18:48:14 NPT 2015-12-01
#Purpose    :	Applied SSH Executer - Execute commands in batch hosts

playbook=$1
shift
hosts=$@

VERBOSE=${VERBOSE-0}

if [ -e private.run.config ]
then
	. private.run.config
else
	. run.config
fi

mkdir -p .ssh/sockets

function echoTask {
    #echo ""
    echo -e "$host | $@"
    echo "===================================="
}
function echoOutput {
    echo -e "=> $@"
}
function echoSuccess {
    local GREEN="\033[0;32m"
    local RESET="\033[0m"
    echo -e "$GREEN=> SUCCESS\n$@$RESET"
}
function echoFailed {
    local RED="\033[0;31m"
    local RESET="\033[0m"
    echo -e "${RED}=> FAILED\n$@$RESET"
}
function echoCommand {
    local RED="\033[0;34m"
    local RESET="\033[0m"
    echo -e "${RED}=> COMMAND: \n$@$RESET"
}

function execCommand {
    verbosity=">/dev/null 2>&1"
    local_verbosity="2>/dev/null"
    #local_verbosity=""
    if [ $VERBOSE -gt 0 ]
    then
	    verbosity=""
    fi
    command="$@"
    ssh_exec_command="$ssh_exec $host sh -c '$@'"
    if [ $VERBOSE -ge 2 ]
    then
	    echoCommand "$ssh_exec_command"
    fi
    output_org=$($ssh_exec_command $verbosity 2>/dev/null < /dev/null)
    return_status=$?
    output=$(echo -en "$output_org" | awk 'BEGIN{ORS="\\\\n"} {print $0}')
    [ -z "$output" ] || output="$output\n"

    if [ $return_status -ne 0 ]
    then
	    echoFailed "$output"
    else
	    echoSuccess "$output"
    fi
    return $return_status
}

for host in $hosts
{
	while read -r task_name; read -r task_command
	do
		echoTask "$task_name"
		execCommand "$task_command" || break
	done <  $playbook
}
