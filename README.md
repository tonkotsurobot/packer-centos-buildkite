
# centos-base

Centos base image with:
- ssh key authentication
- packer v1.2.4
- terraform v0.11.7
- buildkite agent with my key

Build using packer, ansible, on esxi using packer vsphere-iso plugin

From mac:
Download and install packer locally
Install ovftool from vmware
Add path to /etc/paths
/Applications/VMware OVF Tool


export VCENTER_SERVER=CHANGEME
export VCENTER_USERNAME=CHANGEME
export VCENTER_PASSWORD=CHANGEME
packer validate packer-centos.json
packer build packer-centos.json