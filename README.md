# RADIUS Server Appliance with Docker

### This repository implements the [freeRADIUS](https://hub.docker.com/r/freeradius/freeradius-server) images available on DockerHub to host and maintain an AAA server.

Prerequisites
Before you begin, ensure you have the following packages installed on your system:

- Git version 2.34.1
- Docker version 24.0.6, build ed223bc
- Docker Compose version v2.21.0

---

### Getting Started:

First, copy the line below and paste it into your prompt to clone the repository:

```
git clone https://github.com/arthurcadore/capacita-radius
```
If you haven't installed the Git package yet, do it before trying to clone the repository!

Navigate to the project directory:

```
cd ./capacita-radius
```

If you don't have Docker (and Docker Compose) installed on your system yet, you can install it by running the following commands (Script for Ubuntu 22.04):

```
./installDocker.sh
```

**If you had to install Docker, please remember to reboot your machine to grant user privileges for the Docker application.** 

Next, configure the environment files for the application container. You can do this by editing the following files:

#### config/radiusd.conf -> Change the RADIUS Server parameters for host/directory access:

```
name = radiusd

#  Location of config and logfiles.
confdir = ${raddbdir}
modconfdir = ${confdir}/mods-config
certdir = ${confdir}/certs
cadir   = ${confdir}/certs
run_dir = ${localstatedir}/run/${name}

# Should likely be ${localstatedir}/lib/radiusd
db_dir = ${raddbdir}
```

#### config/clients.conf -> Change the RADIUS Server parameters for NAS (Network Authentication Server) connections:

```
client capacitasw1 {
       ipaddr          = 192.0.1.1/24
       secret          = capacitaswpasswd
}

client capacitasw2 {
       ipaddr          = 192.0.1.2/24
       secret          = capacitaswpasswd
}
```

#### config/proxy.conf -> Change the RADIUS Server parameters for network connection and socket:
```
    #  Home servers can be sent Access-Request packets
    #  or Accounting-Request packets.
    #  IPv4 address
       ipaddr = 127.0.0.1

    #  The port to which packets are sent.
    #  Usually 1812 for type "auth", and  1813 for type "acct".
    #  Older servers may use 1645 and 1646.
    #  Use 3799 for type "coa"
    port = 1812

```

### Start Application's Container: 
Run the command below to start docker-compose file: 

```
docker compose up & 
```

The "&" character creates a process id for the command inputed, which means that the container will not stop when you close the terminal. 

---

### Using Application Server:

Once the container is up and running, your NAS devices can authenticate using RADIUS connecting to `1812/UDP`, and check accouting into `1813/UDP` port. 

### Configuring the device to authenticate into the TACACS+ Server: 

To configure the RADIUS clients, you'll need to change the AAA parameters on the NAS (Network Authentication Server) device and point it to ask the RADIUS server parameters (IP and Port). Once this parameters are configurated, the client device can ask to NAS to connect in the network. 

The authentication request sended to NAS will be relayed to RADIUS server, and it will validade if the authentication parameters are correct. 

The repository has a configuration example for a `SG 1002 MR L2+` Intelbras's switch, which you can access in `./examples/switch.conf`. The repository has a configuration example for a `AP 1750 AC` Intelbras's corporative access point, which you can access in `./examples/access-point.conf`. 

--- 

### RADIUS authentication Logs:

You can see the authentication requests in `./logs/radius.log`. Some example requests are displayed below:

```
2024-03-09 20:04:45 +0000	10.100.29.250	arthur	    32	10.123.123.10	shell login failed (no such user)
2024-03-09 20:04:45 +0000	10.100.29.250	carlos	    32	10.123.123.10	shell login failed (no such user)
2024-03-09 20:04:55 +0000	10.100.29.250	admin	    32	10.123.123.10	shell login succeeded
2024-03-09 20:05:17 +0000	10.100.29.250	capacita	32	10.123.123.10	shell login succeeded
2024-03-09 20:06:29 +0000	10.100.29.250	capacita	32	10.123.123.10	shell login succeeded
2024-03-09 20:06:58 +0000	10.100.29.250	capacita	32	10.123.123.10	shell login succeeded
2024-03-09 20:07:25 +0000	10.100.29.250	guest	    32	10.123.123.10	shell login succeeded
2024-03-09 20:08:09 +0000	10.100.29.250	guest	    32	10.123.123.10	shell login succeeded
```

--- 
### Stop Container: 
To stop the running container, use the following command:

```
docker-compose down
```

This command stops and removes the containers and networks defined in the docker-compose.yml file.

--- 

# References/Libraries used: 

[Base image (3.2.3-alpine) used](https://hub.docker.com/r/freeradius/freeradius-server)

[RADIUS documentation for the server](https://freeradius.org/documentation/)