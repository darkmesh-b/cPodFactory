#!/bin/bash
#bdereims@vmware.com

# Modify ESX in cluster to enable nested vSAN Datastore on vSAN Datastore

. ./env

#[ "$1" == "" -o "$2" == "" -o "$3" == "" ] && echo "usage: $0 && exit 1 

PS_SCRIPT=VsanSetFakeSCSIReservations.ps1

SCRIPT_DIR=/tmp/scripts
SCRIPT=/tmp/scripts/$$.ps1

mkdir -p ${SCRIPT_DIR} 
cp ${COMPUTE_DIR}/${PS_SCRIPT} ${SCRIPT} 

sed -i -e "s/###VCENTER###/${VCENTER}/" \
-e "s/###VCENTER_ADMIN###/${VCENTER_ADMIN}/" \
-e "s/###VCENTER_PASSWD###/${VCENTER_PASSWD}/" \
-e "s/###VCENTER_CLUSTER###/${VCENTER_CLUSTER}/" \
${SCRIPT}

echo "Creating vApp '${HEADER}-${1}' with ${4} ESXi."
docker run --rm --dns=${DNS} --entrypoint="/usr/bin/pwsh" -v /tmp/scripts:/tmp/scripts vmware/powerclicore:ubuntu16.04 ${SCRIPT} 2>&1 > /dev/null

rm -fr ${SCRIPT}