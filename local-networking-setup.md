### Setting up Docker for Mac with local networking

This how-to explains how to set up a local MacOS environment with Docker for running microservice-based applications in a local
bridge network.

#### Steps:

1. Download and install Docker for Mac
1. Install the tun/tap OSX networking kernel extension: http://tuntaposx.sourceforge.net/
1. Open a terminal/shell
1. Run the shell script `setup-docker-tap-bridge.sh`.  This creates a docker network and bridges it to the `tap1` interface installed above; 
note this is a minor modification of https://github.com/mal/docker-for-mac-host-bridge.
1. You will be prompted for your su password and also to restart docker.
1. Usually (always?) you will see an error when you run this the first time...about the tap1 interface does not exist.  Just restart Docker.
1. After Docker restarts, run the shell script `setup-docker-tap-bridge.sh` again.
1. To confirm success:
	1. `ifconfig` in a terminal.  You should see the `tap1` interface up and bound to the 172.18.0.1 subnet.
	1. `docker network ls` --> you should see a network named `bnet` with driver `bridge`
	1. `docker network inspect bnet` --> more detailed info.  Make sure you have subnet=172.18.0.0/16 and gateway=172.18.0.1
1. Execute the docker-compose file to bring up the networking support containers: `docker-compose -f local-network-compose.yaml up -d`
1. If you don't have an entry for the `docker.local` domain in `/etc/resolver/`, then add one:
	1. `su -`
	1. `echo "nameserver 172.18.0.3" | tee -a /etc/resolver/docker.local`
	1. `exit`

_Note:_ You will need to re-run steps 4, 6, and 7 each time you reboot your machine.

#### To bring up a container:

There are three things you need to do to bring containers up in this environment:

1. Pass an environment variable (via the `-e` option) with the name `SERVICE_NAME` and a value of what you want the container's name to be in DNS
1. If the container's image does not expose any ports in its Dockerfile, you need to expose them at runtime with `--expose [port]`
1. Make sure to attach the container to the `bnet` network with `--net bnet`

Here is an example of bringing up a Java 8 / Tomcat 8 based web server with the name `tomcat.docker.local`:

`docker run -d --name tomcat -e SERVICE_NAME=tomcat --expose 80 --net bnet ojbc/java8-tomcat8`

```
$: ping tomcat.docker.local
PING tomcat.docker.local (172.18.0.5): 56 data bytes
64 bytes from 172.18.0.5: icmp_seq=0 ttl=64 time=0.331 ms
64 bytes from 172.18.0.5: icmp_seq=1 ttl=64 time=0.458 ms
^C
--- tomcat.docker.local ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.331/0.395/0.458/0.063 ms
```

```
$: curl -s http://tomcat.docker.local | head -20



<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Apache Tomcat/8.0.30</title>
        <link href="favicon.ico" rel="icon" type="image/x-icon" />
        <link href="favicon.ico" rel="shortcut icon" type="image/x-icon" />
19 14:57 scott ~/git-repos/SEARCH-NCJIS/docker []
$: curl -s http://tomcat.docker.local | head -20



<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Apache Tomcat/8.0.30</title>
        <link href="favicon.ico" rel="icon" type="image/x-icon" />
        <link href="favicon.ico" rel="shortcut icon" type="image/x-icon" />
        <link href="tomcat.css" rel="stylesheet" type="text/css" />
    </head>

    <body>
        <div id="wrapper">
            <div id="navigation" class="curved container">
                <span id="nav-home"><a href="http://tomcat.apache.org/">Home</a></span>
                <span id="nav-hosts"><a href="/docs/">Documentation</a></span>
                <span id="nav-config"><a href="/docs/config/">Configuration</a></span>
                <span id="nav-examples"><a href="/examples/">Examples</a></span>
```

_Note:_ if you want to start up a container and not have it get an entry in DNS, pass an environment variable (via `-e`) with the name `SERVICE_IGNORE` and a value of true.