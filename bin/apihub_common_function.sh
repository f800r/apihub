#!/bin/sh

function getarg() { 
  local VAR_NAME=$1 NEXT_ARG=${BASH_ARGV[$((BASH_ARGC - OPTIND))]}
  if [[ $NEXT_ARG =~ ^-$ ]] || [[ $NEXT_ARG =~ ^[^-] ]]; then
    eval $VAR_NAME="$NEXT_ARG"
    let "OPTIND++"
  else 
    eval unset $VAR_NAME
  fi
}

function read_rc_file() {
  if [[ -r ~/.$(basename ${0})rc ]];then
    while IFS='=' read -r key value; do
      eval $key="$value"
    done <<<"$( cat ~/.$(basename ${0})rc \
      | sed -e'/^[a-zA-Z0-9_]*=/!d' -e'/^#/d' -e'/^ *$/d' \
    )"
  fi
}

function get_password() {
  if [[ -n "${PASSWORD}" ]];then
    echo "${PASSWORD}"
  elif [[ -n "${PASSWORD_COMMAND}" ]];then
    echo "$(${PASSWORD_COMMAND})"
  else
    read -r -s -p "enter password: "
    echo "${REPLY}"
  fi
}
