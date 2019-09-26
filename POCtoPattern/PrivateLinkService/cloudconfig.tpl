#cloud-config
package_upgrade: true
runcmd:
 - echo "Created by Azure terraform-vmss-cloudinit module." | sudo dd of=/tmp/terraformtest &> /dev/null
 
 #!/bin/bash
# https://unix.stackexchange.com/questions/20784/how-can-i-resolve-a-hostname-to-an-ip-address-in-a-bash-script
# ToDo
#  1. validate when hostname resolves to multiple IPs.. like rt.com
#  2. logging to syslog
#  3. add as cron job that detects changes
#
- sqlManagedInstance="{$sql_mi_fqdn}"
- echo $sqlManagedInstance
#
- for h in $sqlManagedInstance
- do
-	host $h 2>&1 > /dev/null
-	if [ $? -eq 0 ]
-	then
-		echo "$h is a FQDN"
-		host $h
-		ip=`host $h | awk '/has address/ { print $4 }'`

-		if [ -n "$ip" ]; then
-			echo IP: $ip
-		else
-			echo Could not resolve hostname.
-		fi
-	else
-		echo "$h is not a FQDN"
-	fi

- firewall-cmd --permanent --zone=public --add-service=mssql
- firewall-cmd --permanent --zone=public --add-masquerade
- firewall-cmd --permanent --zone=public --add-forward-port=port=1433:proto=tcp:toport=1433:toaddr=$ip
- firewall-cmd --reload

    # check if IP Changed

- done