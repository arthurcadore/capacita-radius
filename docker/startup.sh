# change the owner of the radius configuration files
chown -R root:root /etc/raddb/*

# execute the radius server
/opt/sbin/radiusd -f &

# verify if the radius server is running
echo "################################################"
echo "Verifing RADIUS server services..."
ps aux

echo "################################################"
echo "Verifing RADIUS server ports..."
nestat -a

# mantain the container running
tail -f /dev/null
