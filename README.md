Fireball
========

Iptables configuiration script

Project aims to add a bit of simplicity to the iptables configuration.

## Disclaimer
 This script has been testen in Gentoo 3.5.7 only and author does not warranty that it will work anywhere else.
 Provided "as is" without warranty of any kind.
 Lisense LGPL v2.

## Prerequisites
 * Gentoo 3.5.7
 * Awk 4.0.1
 * Sed 4.2.10r-1
 * Net-tools 1.60_p20120127084908
 * Ipset 6.15
 * Iptables 1.4.6.13

## Features
 * Modular configuration
 * Support for dnsmasq, samba, miniupnpd, transmission
 * Zero script configuration required (hope so)
 * ...

### Supported apps
 * Dnsmasq - dhcp&dns server
 * MiniUPnP - upnp server
 * Transmission - bittorrent client
 * Mediatomb - DLNA server
 * Samba - network shares
 
## Configuration

Please note, this script is not for production use and has been tested in very limited environment.
It may run well with another software versions than listed above, but this is not quaranteed.
It does not contain any fool-proof checks, you can run script even if not all dependencies exists.
For the first run please use the most restricted account to check that nothing will go wrong.

### Kernel 
Before using this script you have to carefully configure you kernel to be sure that nothing will go wrong at first time.
```
  [---------------------------------------------------------]
  | <*> Netfilter connection tracking support               |
  | -*-   Connection mark tracking support                  |
  | <*>   Connection tracking netlink interface             |
  | -*- Netfilter Xtables support (required for ip_tables)  |
  | *** Xtables combined modules ***                        |
  | <*>   set target and match support                      |
  | <*>   "conntrack" connection tracking match support     |
  | <*>   "state" match support                             |
  [---------------------------------------------------------]
```
```
  [---------------------------------------------------------]
  | --- IP set support                                      |
  | (256) Maximum number of IP sets                         |
  | < >   bitmap:ip set support                             |
  | < >   bitmap:ip,mac set support                         |
  | < >   bitmap:port set support                           |
  | <*>   hash:ip set support                               |
  | <*>   hash:ip,port set support                          |
  | < >   hash:ip,port,ip set support                       |
  | <*>   hash:ip,port,net set support                      |
  | <*>   hash:net set support                              |
  | <*>   hash:net,port set support                         |
  | < >   hash:net,iface set support                        |
  | <*>   list:set set support                              |
  [---------------------------------------------------------]                                                                                                       
```

### Tools
These tools are quite common and they should be available on nearly any linux host, but please make sure that they are availble.
```
 emerge net-tools
 emerge awk
 emerge sed
 emerge ipset
 emerge iptables
```

### Install
 * Download this package and unpack (or checkout from Github) at place where you can run it.
 * Edit ```fireball/conf/20.interfaces.conf``` and replace ```EXTIF``` (wan) and ```INTIF1`` (lan)` values with your interface names
 * run ```ipt.sh``` from the package root
 
Hope, you'll see no errors at this point. If there will be any, feel free to file a bug

## Deep in details
Fireball script highly depends on Ipset tool to configure allow/block rules for the different services.

### Set block_bad_net
Script name: $SET_BLOCK_SOURCE
Contains: list of subnets to block on wan interface, by default private nets, multicast ranges and apipa/zeroconf
Defined: conf/sets/10.bad-sources.conf

### Set dhcp_leases
Script name: $SET_DHCP_LEASES
Contains: list of ips, assigned statically or/and by DHCP server, only these ips are allowed on the lan interface
Defined: conf/sets/30.static-leases.conf

### Set block_int_srv
Script name: $SET_BLOCK_INT_SERVICES
Contains: list of ports to block on the lan interface
Defined: conf/sets/40.common-blocks.conf

### Set block_ext_srv
Script name: $SET_BLOCK_EXT_SERVICES
Contains: list of ports to block on the wan interface
Defined: conf/sets/40.common-blocks.conf

### Set block_int_srv_frw
Script name: $SET_BLOCK_INT_SERVICES_FRW
Contains: list of ports to block when forwarding requests from lan
Defined: conf/sets/40.common-blocks.conf

### Set allow_int_srv_tcp
Script name: $SET_INT_SERVICES_IN_TCP
Contains: list of tcp ports to serve requests from lan
Defined: conf/sets/20.default-services.conf and in the net/apps/*

### Set allow_int_srv_udp
Script name: $SET_INT_SERVICES_IN_UDP
Contains: list of udp ports to serve requests from lan
Defined: conf/sets/20.default-services.conf and in the net/apps/*

### Set allow_ext_srv
Script name: $SET_EXT_SERVICES_IN
Contains: list of ports to serve requests from wan
Defined: conf/sets/20.default-services.conf and in the net/apps/*

### Set allow_int_srv_ex_in
Script name: $SET_INT_SERVICES_EX_IN
Contains: list of security exclusions to be served for lan incoming packets, e.g. allows samba for listening to broadcasts
Defined: conf/sets/20.default-services.conf and in the net/apps/*

### Set allow_int_srv_ex_out
Script name: $SET_INT_SERVICES_EX_OUT
Contains: list of security exclusions to be served for lan outgoing packets, e.g. allows dnsmasq to anwser from 255.255.255.255
Defined: conf/sets/20.default-services.conf and in the net/apps/*

## Project structure
```
  - func.js     - common functions
  |- conf       - configuration files
    - *.conf
    |- sets     - ip sets definitions
      - *.conf
  |- net        - newtork setup scripts
    - *.conf
   |- chains    - iptables chains
     - *.conf
   |- apps      - per-app setup scripts
     - *.conf
   |- rules     - iptables rules
     - *.conf
     |- custom  - place to store custom rules
       - *.conf
```  
All files start from a number to keep natural sort order while iterating through a directory.
Script name pattern is /[0-9]+\..+\.conf/

## Enjoy!

Please, drop me a line if this script will work for you.
