#!/bin/sh
sudo ip netns add ns1
sudo ip netns add router
sudo ip netns add ns2
sudo ip link add ns1-veth0 type veth peer name gw-veth0
sudo ip link add ns2-veth0 type veth peer name gw-veth1

sudo ip link set ns1-veth0 netns ns1
sudo ip link set gw-veth0 netns router
sudo ip link set gw-veth1 netns router
sudo ip link set ns2-veth0 netns ns2

sudo ip netns exec ns1 ip link set ns1-veth0 up
sudo ip netns exec router ip link set gw-veth0 up
sudo ip netns exec router ip link set gw-veth1 up
sudo ip netns exec ns2 ip link set ns2-veth0 up

sudo ip netns exec ns1 ip address add 192.0.2.1/24 dev ns1-veth0
sudo ip netns exec router ip address add 192.0.2.254/24 dev gw-veth0
sudo ip netns exec router ip address add 198.51.100.254/24 dev gw-veth1
sudo ip netns exec ns2 ip address add 198.51.100.1/24 dev ns2-veth0



sudo ip netns exec ns1 ping -c 3 192.0.2.254 -I 192.0.2.1