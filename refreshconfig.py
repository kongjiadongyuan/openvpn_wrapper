#!/usr/bin/python3

import os
import ipaddress

with open('env.sh') as f:
    exec(f.read())

# delete old config file
cmd = f"""docker run -v {SERVER_VOLUME_NAME}:/etc/openvpn -it --rm kylemanna/openvpn sh -c "rm /etc/openvpn/openvpn.conf* /etc/openvpn/ovpn_env.sh*" """
os.system(cmd)

# parse route config
with open('side_route_config') as f:
    content = f.read()
content = content.split('\n')
while True:
    if content[-1] == '':
        content = content[:-1]
    else:
        break
route_list = {}
for item in content:
    tmpitem = item.split()
    nw = ipaddress.ip_network(tmpitem[1])
    hostname = tmpitem[0]
    if not hostname in route_list.keys():
        route_list[hostname] = []
    toinsert = {}
    toinsert['subnet'] = str(nw.network_address)
    toinsert['prefix_length'] = str(nw.prefixlen)
    toinsert['netmask'] = str(nw.netmask)
    route_list[hostname].append(toinsert)

# generate openvpn.conf
cmd = f"docker run -v {SERVER_VOLUME_NAME}:/etc/openvpn -it --rm kylemanna/openvpn ovpn_genconfig -u {CONNECT_METHOD}://{SERVER_ADDR}:{CONNECT_PORT} -d -D -b -c -s {VPN_SUBNET}"
for hostname in route_list.keys():
    for item in route_list[hostname]:
        cmd += f''' -r "{item['subnet']}/{item['prefix_length']}" '''
        cmd += f''' -p "route {item['subnet']} {item['netmask']}" '''
print(cmd)
os.system(cmd)

# generate /etc/openvpn/ccd/*

os.system(f"""docker run -v {SERVER_VOLUME_NAME}:/etc/openvpn -it --rm kylemanna/openvpn sh -c "rm /etc/openvpn/ccd/*" """)
for hostname in route_list.keys():
    toecho = ''
    for item in route_list[hostname]:
        toecho += f"iroute {item['subnet']} {item['netmask']}\n"
    cmd = f""" echo '{toecho}' | docker run -v {SERVER_VOLUME_NAME}:/etc/openvpn -i --rm kylemanna/openvpn tee /etc/openvpn/ccd/{hostname} """
    os.system(cmd)

# restart docker
cmd = f"""docker container restart {SERVER_DOCKER_NAME}"""
os.system(cmd)
