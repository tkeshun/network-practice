#!/bin/sh
echo "create Network Namespace"
sudo ip netns add n1
sudo ip netns add n2
sudo ip netns list
sudo ip link add n1-veth0 type veth peer name n2-veth0
ip link show | grep veth
sudo ip link set n1-veth0 netns n1
sudo ip link set n2-veth0 netns n2
sudo ip netns exec n1 ip address add 192.0.2.1/24 dev n1-veth0
sudo ip netns exec n2 ip address add 192.0.2.2/24 dev n2-veth0
sudo ip netns exec n1 ip link set n1-veth0 up
sudo ip netns exec n2 ip link set n2-veth0 up
sudo ip netns exec n1 ping -c 3 192.0.2.2
# sudo ip netns delete n1
# sudo ip netns delete n2
# sudo ip --all netns delete