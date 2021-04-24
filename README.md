![new_banner](https://github.com/yagoplx/x86routertools/raw/main/brand/newbanner.png)  

[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/yagoplx/x86routertools/issues)
![build](https://github.com/yagoplx/x86routertools/actions/workflows/postwork.yml/badge.svg)
[![GitHub release](https://img.shields.io/github/release/Naereen/StrapDown.js.svg)](https://github.com/yagoplx/x86routertools/releases/)  
[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)
# Table of Contents
* [Introduction to x86routertools](#whatis)
* [Using the command line tools](#cmdline)
* [Using the daemon](#daemon)
* [System requirements](#sysreq)
* [Installation](#install)
* [Configuration options](#cfgopt)
* [Scripts and examples](#scripts)
## <a name="whatis"></a>Introduction to x86routertools
This is a command line toolkit written in Bash that aims to turn a regular x86_64 computer running GNU/Linux into a wireless router or access point (AP), whilst managing things like system services, alerts, system LEDs and making sure the network is always up via watchdog daemons.

Similar in nature to create_ap, this goes a bit further with the configurability of the whole program and the scope. It can do:
* Watch and restart wireless APs when needed, with per-AP configuration and simple masquerading/fowarding rules.
* Watch and restart the internet-facing interface when needed via user-made scripts (x86routertools takes care of 'detecting' connectivity)
* Automatically restart a service 'stack' on network initialization, for DNS sinkholing setups for example.
* Manage queue disciplines with CAKE SQM and pre-defined categories
* Manage ath9k Wi-Fi cards' special features, like digital predistortion and ack timeout estimation.
* Manage generic Wi-Fi AP features, like power saving, retransmission, regulatory domains and transmit power.
* Optimize the network stack, for example, toggling on BBRv2/v1 if present.
* Offer command line tools for wireless AP management and debugging.

x86routertools is currently not compatible with NetworkManager, but a patch to set predefined interfaces as 'unmanaged' to fix this should be easy to make.

## <a name="cmdline"></a>Using the command line tools
x86routertools comes with many verbs that can be used to get information on the system. 

For example, you can check what MCS rates your phone is using on the connection, to measure the quality of the service it is getting:
* Get the MAC address of the device by looking at the list of connected devices:
* `routertools ls`
* Then, you can pull up the real-time rate display with the AP's interface name:
* `routertools display-rates wlan0 aa:bb:cc:dd:ee:ff`

You can also toggle many runtime options of a wireless interface. For example, to turn on LNA mixing on ath9k cards (the daemon can do this for you, too):
* `routertools lnamix-on wlan0`
* Or, to set it on all APs on the system:
* `routertools lnamix-on`

Calling `routertools --help` should be enough to get you a full, descriptive list of commands.

## <a name="daemon"></a>Using the daemon
The x86routertools daemon has two instances, Wi-Fi and internet, which are independent from each other.

Their function is to watch the system-wide SQM/qdisc configuration, and watch the AP interfaces and the internet-facing interface respectively. How they work and what they do is extensively configurable via files in `/etc/routertools.d/`. The most important of them, containing the most options, is arguably `x86routertools.conf`.

To start the internet daemon, you can use:
`sudo systemctl start routertoolsd-inet`

To start the wireless AP daemon:
`sudo systemctl start routertoolsd-wifi@wlan0`
Where, of course, wlan0 is the name of one interface you configured in `/etc/routertools.d/wifi-access-points`.

The daemons will regularly output their status to the system log, send desktop notifications, or make a light blink somewhere.

## <a name="sysreq"></a>System requirements
* Access point-capable Wi-Fi card (ath9k is preferred but optional)

Must be installed:
* systemd
* netstat
* iw
* ifconfig
* iptables
* hostapd

Optional:
* wget, for grabbing hostapd configuration reference.
* haveged or rngd, without, WPA/WEP performance may suffer
* A firewall like ufw, shorewall or firewalld. x86routertools *will not block any vulnerable ports for you*!
* A DHCP server like Pi-hole or dnsmasq, otherwise your clients will not be able to use DHCP. x86routertools *will not configure DNS for you*!
## <a name="install"></a>Installation
x86routertools is normally installed to `/usr/bin`. Other necessary directories like in `/etc` will be populated by the program on first run.

To install it on your system:
* Clone the repository somewhere:
* `git clone https://github.com/yagoplx/x86routertools.git`
* `cd x86routertools`
* Move the files around:
* `cp -v routertools /usr/bin/`
* `cp -v systemd/* /etc/systemd/system/`
* Populate the configuration directories:
* `routertools reset-cfg`

It should be ready for configuration, though you may also want to run a `systemctl daemon-reload` if you want to try out the daemon right away.

Configuration is well documented and required, check the new files at `/etc/routertools.d` for examples and info. For example, to register a new wireless interface with x86routertools, you will want to set up them at `/etc/routertools.d/wifi-access-points`.

Each wireless interface should have two files in there: a interfacename.conf, and a interfacename_hostapd.conf. Example files with all possible options documented are provided for you to copy/rename.

As for the internet facing interface, you should set up scripts to set them up and down at `/etc/routertools.d/scripts`. The default is to just call the Arch Linux pppoe-start and pppoe-stop commands for PPPoE. The daemon will call the stop script when it restarts the interface, and then the start script. The command line tools also can use these scripts as well.

You can have the daemon start on boot for the standard wifi router experience:
* `sudo systemctl enable routertoolsd-inet`
* `sudo systemctl enable routertoolsd-wifi@interface_name`

#### <a name="cfgopt"></a>Configuration options
Configuration is system-wide and is done via files in `/etc/routertools.d`    

[List of configuration options](https://github.com/yagoplx/x86routertools/wiki/Configuration)


#### <a name="scripts"></a>Scripts and examples
[Take me to the wiki page](https://github.com/yagoplx/x86routertools/wiki/Scripts-and-Examples)
