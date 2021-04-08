# x86routertools

## Originally up on https://gitlab.com/yagocl/x86routertools/-/raw/master/routertools, moved to GitHub. I no longer have that account.

   
**Scripts for using any Linux PC with a capable WiFi NIC as a fully-fledged wireless access point.     

Pretty much just glue, kind of like create_ap, but takes a different approach. You probably can't use this with NetworkManager.**     

x86routertools can be installed by downloading the git repository and copying `routertools` to /usr/bin:     
    
`sudo wget https://gitlab.com/yagocl/x86routertools/-/raw/master/routertools -O /usr/bin/routertools; sudo chmod og+xr /usr/bin/routertools`  
  
Then generating the base configuration files:        
    
`sudo routertools reset-cfg`     


It can check and automatically start up hostapd with your custom configurations, making it very useful in cron jobs (as a watchdog):    

`* * * * * routertools check-wifi`     <-- checks and restarts AP if interface down or hostapd down       

`* * * * * routertools check-inet`     <-- checks and restarts internet if its interface is down

**Along with checking if the network is live, it can also be configured to send a warning to TTY or X11 desktop about the problem.** Though, it will attempt to solve the issue on its own if properly set up. (by restarting things, it can't fix the likes of a snapped cable)     

It can check and automatically set up Cake SQM (+ BBRv1/v2) on new network interfaces, to pretty much nullify bufferbloat. It does this best as a crontab watchdog, and categorizes network interfaces in profiles, some configurable with traffic shaping. This is similar to what sqm-scripts does, but the code is different:      

`* * * * * routertools qdisc`    

If you don't like the idea, you can also use it as a systemd service with the included service files:     

From the source folder, do:      

`sudo cp systemd/* /etc/systemd/system/`

`sudo systemctl daemon-reload`

Then activate the services, like this, once you're done configuring:

`sudo systemctl enable --now routertoolsd-inet`

`sudo systemctl enable --now routertoolsd-wifi@INTERFACE_NAME`

**Configuration is done via text file editing, you can find every relevant option in folder /etc/routertools.d/**     

It automates tedious tasks such as setting up NAT, ath9k settings, dynack, regdomain setting, ... and service restarting that cannot be done within hostapd.     

Any form of internet access is supported via scripts in routertools.d, but Arch Linux's pppd scripts are defaults.      

For example, you could have scripts setting up/down an Ethernet link with DHCP.

Any amount of AP interfaces, hostapd instances and virtual bssids is supported, via profiles.       

A valid profile has two files:         

`/etc/routertools.d/wifi-access-points/[interface_name].conf`  <-- standard x86routertools interface config file          

`/etc/routertools.d/wifi-access-points/[interface_name]_hostapd.conf` <-- your custom hostapd.conf    

**System Requirements:      

`An AP capable network adapter (Preferably ath9k)`     

`systemd`        

`netstat`        

`iw`     

`ifconfig`           

`hostapd`**

x86routertools is free software licensed under the GPLv3.         

Copyright (C) 2021 Yago Mont' Alverne         
