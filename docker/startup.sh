
# execute the radius server
radiusd -f & 

# verify if the radius server is running
echo "Verifing RADIUS server services..."
ps aux 
nestat -a

# mantain the container running
tail -f /dev/null

