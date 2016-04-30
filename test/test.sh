#!/bin/bash

#Author: Pavol Loffay, xloffa00@stud.fit.vutbr.cz
#Date: 27.3.2013
#Project: Skript na automaticke spustanie 
#         nastrojov na testovanie siete
#         meria TCP a UDP priepustnost

######### Klient ########
if [ $1 = "C" ]; then
    #overenie nazvu testu
    if [ $# -ne 2 ]; then
        echo "Spustite s dvoma parametremi C <nazov testu>!"
        exit 1
    fi

    echo "Client testing..."
    HOME=/home/pavol
    TIME=20
    UDP_BAN=100M
#    UDP_BAN=2M pre Svajciarsko
#    UDP_BAN=3500k

    #iperf
    echo "Iperf TCP"
    iperf -c sec6net-mv1.fit.vutbr.cz -t $TIME > $2_iperf_tcp.out 
    echo "Iperf UDP"
    iperf -c sec6net-mv1.fit.vutbr.cz -p 6009 -u -b "$UDP_BAN" -t $TIME > \
        $2_iperf_udp.out
    #netperf
    echo "Netperf"
    $HOME/netperf-2.6.0/src/netperf -H sec6net-mv1.fit.vutbr.cz -l $TIME > \
        $2_netperf_tcp.out
    #thrulay
    echo "Thrulay TCP"
    $HOME/thrulay-0.9/src/thrulay -t $TIME sec6net-mv1.fit.vutbr.cz > \
        $2_thrulay_tcp.out
    echo "Thrulay UDP"
    $HOME/thrulay-0.9/src/thrulay -t $TIME -u "$UDP_BAN" sec6net-mv1.fit.vutbr.cz > \
        $2_thrulay_udp.out
    #nuttcp
    echo "Nuttcp TCP"
    $HOME/nuttcp/nuttcp -T $TIME sec6net-mv1.fit.vutbr.cz > $2_nuttcp_tcp.out
    echo "Nuttcp UDP"
    $HOME/nuttcp/nuttcp -T $TIME -u -R "$UDP_BAN" sec6net-mv1.fit.vutbr.cz > \
        $2_nuttcp_udp.out
    #bwping 
    #echo "bwping"
    #$HOME/bwping-1.7/bwping -b 95000 -s 55000 -v 9000000 sec6net-mv1.fit.vutbr.cz >\
    #    $2_bwping.out
    exit 0

######### Server ########
elif [ $1 = "S" -a $# -eq 1 ]; then 
    echo "Starting server..."
    HOME_BP=/home/xloffa00
    #iperf
    echo "Starting Iperf"
    iperf -s &
    iperf -s -u -p 6009 & 
    #netperf
    echo "Starting Netperf"
    $HOME_BP/netperf-2.6.0/src/netserver
    #thrulay
    echo "Starting Thrulay"
    $HOME_BP/thrulay-0.9/src/thrulayd 
    #nuttcp 
    echo "Starting Nuttcp"
    $HOME_BP/nuttcp/nuttcp -S
    exit 0;

######### Server KILLALL ########
elif [ $1 = "K" -a $# -eq 1 ]; then
    echo "Killing deamons..."
    echo "iperf"
    killall iperf
    echo "netperf"
    killall netserver
    echo "thrulayd"
    killall lt-thrulayd
    echo "nuttcp"
    killall nuttcp
    exit 0;

else
    echo -e "\t \$test [SCK]"
    echo -e "\t S - server, C - klient, K - zabije procesy deamonov"
    echo -e "\t C <nazov testu, napriklad brno1>"
    echo -e "\t\t nazov ovplyvni nazov vystupnych suborov"
    exit 1
fi

