#!/bin/bash
#
# Part of fireball iptables init script
#
# Author: Ilya Lebedev <ilya@lebedev.net>
# License: LGPL v2
#
############################################################################################################
# Fireball functions
############################################################################################################
#
###
# Loader
 function load () {
     for pre in $PWD/$1/[0-9]*.conf
     do
         source $pre
     done
 }
#
##
# Function calculates number of bit in a netmask
function mask2cidr () {
    nbits=0
    IFS=.
    for dec in $1 ; do
        case $dec in
            255) let nbits+=8;;
            254) let nbits+=7;;
            252) let nbits+=6;;
            248) let nbits+=5;;
            240) let nbits+=4;;
            224) let nbits+=3;;
            192) let nbits+=2;;
            128) let nbits+=1;;
            0);;
            *) echo "Error: $dec is not recognised"; exit 1
        esac
    done
    echo "$nbits"
}
#
##
# echo helpers
 function info () {
     $E -e "\e[32;01m*\e[0m $*"
     logger "[ipt.info] $*"
 }
 function err () {
     $E -e "\e[31;01m*\e[0m $*"
     logger "[ipt.err] $*"
 }
 function dbg () {
     $E -e "\e[33;01m$*\e[0m"
     logger "[ipt.dbg] $*"
 }
 function title () {
     $E -e "\e[0;01m$*\e[0m"
     logger "[ipt.title] $*"
 }
#
###
# Ipset helpers
##
# Adds values to ip set
# $1 - set name
# $2... - ips
 function set_add_ip () {
     info "Set '$1': \c"
     $IPSET create -! $1 hash:ip hashsize 4
     for a in ${@:2}
     do
        $IPSET add -! $1 "$a"
        dbg "$a \c"
     done
     echo ""
 }
#
##
# Adds values to net set
# $1 - set name
# $2... - nets
 function set_add_net () {
     info "Set '$1': \c"
     $IPSET create -! $1 hash:net hashsize 4
     for a in ${@:2}
     do
        $IPSET add -! $1 "$a"
        dbg "$a \c"
     done
     echo ""
 }
#
##
# Adds values to port set
# $1 - set name
# $2... - ports
 function set_add_port () {
     info "Set '$1': \c"
     $IPSET create -! $1 bitmap:port range 0-65535
     for a in ${@:2}
     do
        $IPSET add -! $1 "$a"
        dbg "$a \c"
     done
     echo ""
 }
#
##
# Adds values to ip,port set
# $1 - set name
# $2 - ip
# $3 - protocol
# $4... - ports
 function set_add_ip_port () {
     info "Set '$1' $2@$3: \c"
     $IPSET create -! $1 hash:ip,port hashsize 4
     for a in ${@:4}
     do
        $IPSET add -! $1 "$2,$3:$a"
        dbg "$a \c"
     done
     echo ""
 }
#
##
# Adds values to net,port set
# $1 - set name
# $2 - ip
# $3 - protocol
# $4... - ports
 function set_add_net_port () {
     info "Set '$1' $2@$3: \c"
     $IPSET create -! $1 hash:net,port hashsize 4
     for a in ${@:4}
     do
        $IPSET add -! $1 "$2,$3:$a"
        dbg "$a \c"
     done
     echo ""
 }
#
##
# Adds values to ip,port,net set
# $1 - set name
# $2 - ip
# $3 - protocol
# $4 - net
# $5... - ports
 function set_add_ip_port_net () {
     info "Set '$1' $3:$2@$4: \c"
     $IPSET create -! $1 hash:ip,port,net hashsize 4
     for a in ${@:5}
     do
        $IPSET add -! $1 "$2,$4:$a,$3"
        dbg "$a \c"
     done
     echo ""
 }
#
##
# Flushed set contents
 function set_flush () {
     $IPSET -q flush $1
 }

