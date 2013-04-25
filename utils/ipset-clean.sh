#!/bin/bash
#
# Ipset cleanup script
# removes everything not used by iptables
for a in `ipset list -n`; do
 ipset -q destroy $a;
done;
ipset list -n;
