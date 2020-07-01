yum -y update
yum install -y openssh-server
yum install -y ansible
yum install -y wget
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
useradd -m emario && usermod -aG wheel emario
echo -e "changeme\nchangeme" | passwd emario
mkdir -p /home/emario/.ssh && chmod 700 /home/emario && chown -R emario:emario /home/emario
mkdir /tmp/ssh
wget -P /tmp/ssh http://192.168.1.30:8000/authorized_keys
wget -P /tmp/ssh http://192.168.1.30:8000/config/config
wget -P /tmp/ssh http://192.168.1.30:8000/key/emario_private
mv /tmp/ssh/* /home/emario/.ssh && chmod -R 700 /home/emario/.ssh && chown -R emario:emario /home/emario/.ssh
mv /tmp/sshd_config /etc/ssh/sshd_config && chmod 644 /etc/ssh/sshd_config && chown -R root:root /etc/ssh/sshd_config
service sshd start

#setup buildkite
sh -c 'echo -e "[buildkite-agent]\nname = Buildkite Pty Ltd\nbaseurl = https://yum.buildkite.com/buildkite-agent/stable/x86_64/\nenabled=1\ngpgcheck=0\npriority=1" > /etc/yum.repos.d/buildkite-agent.repo'
yum -y install buildkite-agent
sed -i "s/xxx/2adef1dc99aaacd9489e39ec959da33f8bc0eff03261c746e3/g" /etc/buildkite-agent/buildkite-agent.cfg
echo 'tags="home=true,vm=true"' >> /etc/buildkite-agent/buildkite-agent.cfg
mkdir /var/lib/buildkite-agent/.ssh/
cp /home/emario/.ssh/emario_private  /var/lib/buildkite-agent/.ssh/buildkite-private
wget http://192.168.1.30:8000/config/buildkite-ssh-config -O /var/lib/buildkite-agent/.ssh/config
chown -R buildkite-agent:buildkite-agent /var/lib/buildkite-agent/
chmod -R 700 /var/lib/buildkite-agent/.ssh/
systemctl enable buildkite-agent && sudo systemctl start buildkite-agent

