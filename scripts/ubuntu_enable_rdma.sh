sudo apt-get install libdapl2 libmlx4-1
sudo sed -i -e 's/# OS.EnableRDMA=y/OS.EnableRDMA=y/' /etc/waagent.conf
sudo sed -i -e 's/# OS.UpdateRdmaDriver=y/OS.UpdateRdmaDriver=y/' /etc/waagent.conf
sudo service walinuxagent restart
