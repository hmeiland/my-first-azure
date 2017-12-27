sudo apt-get -y install libdapl2 libmlx4-1 bc
sudo sed -i -e 's/# OS.EnableRDMA=y/OS.EnableRDMA=y/' /etc/waagent.conf
sudo sed -i -e 's/# OS.UpdateRdmaDriver=y/OS.UpdateRdmaDriver=y/' /etc/waagent.conf
sudo sed -i -e 's/kernel.yama.ptrace_scope = 1/kernel.yama.ptrace_scope = 0/' /etc/sysctl.d/10-ptrace.conf
sudo sysctl -w kernel.yama.ptrace_scope=0
sudo bash -c 'echo "*		hard	memlock		unlimited" >> /etc/security/limits.conf'
sudo bash -c 'echo "*		soft	memlock		unlimited" >> /etc/security/limits.conf'
sudo bash -c 'echo "session required pam_limits.so" >> /etc/pam.d/common-session'
sudo service walinuxagent restart
