# change the owner of the radius configuration files
chown -R root:root /etc/raddb/*

# execute the radius server
/opt/sbin/radiusd -X