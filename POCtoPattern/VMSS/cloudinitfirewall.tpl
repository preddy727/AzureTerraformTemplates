#cloud-config

package_upgrade: true

runcmd:

 - echo "Created by Azure terraform-vmss-cloudinit module." | sudo dd of=/tmp/terraformtest &> /dev/null
 - echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
 - systemctl enable firewalld
 - systemctl start firewalld
 - firewall-cmd --permanent --zone=public --add-service=mssql
 - firewall-cmd --permanent --zone=public --add-masquerade
 - firewall-cmd --permanent --zone=public --add-forward port=port=${forward_port}:proto=tcp:toport=${to_port}:toaddr=${to_addr}
 - firewall-cmd --reload
