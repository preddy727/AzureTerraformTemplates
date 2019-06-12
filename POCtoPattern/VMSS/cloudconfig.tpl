#cloud-config

package_upgrade: true

runcmd:

 - echo "Created by Azure terraform-vmss-cloudinit module." | sudo dd of=/tmp/terraformtest &> /dev/null
 - [ wget, "https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war", -O, /usr/share/tomcat/webapps/sample.war ]