Problem:	Internet pages not loaded after connecting to Cisco VPN (Enghouse)

I've stored network information into no-vpn and vpn so you can compare them.


Configuration
-------------
SEE: ipconfig.txt

- there are multiple interfaces
	- ethernet/wireless	- for internet connection
		auto DHCP and DNS (DNS server points to router)
	- Cisco AnyConnect Client - for VPN
		IP and DNS come from VPN server, route for VPN added automatically

Current status
--------------
- interfaces connected		OK
- ping 8.8.8.8				OK
- route print				OK - default GW points to internet interface
- ping index.hu				ERR - DNS cannot be resolved


Problem
--------
Internet names not resolved into IP address.
	
	
Analysis
--------
What I found?
- routing OK
- Both interface have DNS server, but if VPN active DNS settings for VPN interface is asked but it cannot resolve public interface addresses.
	
	Why it does not awitch to secondary DNS server or DNS server of ethernet/wireless?
	
		The only time a resolver will failover to the secondary DNS server is when the primary DOES NOT RESPOND AT ALL.
		But here the 1st DNS server reaponded.
		
Fix
---
Why DNS server of VPN used instead of DNS configured into ethernet/wireless interface?
Call:

	route print
	
	
		IPv4 Route Table
		===========================================================================
		Active Routes:
		Network Destination        Netmask          Gateway       Interface  Metric
				  0.0.0.0          0.0.0.0      192.168.8.1    192.168.8.100     25			<< ethernet/wireless interface
				 10.0.0.0        255.0.0.0     10.255.248.1    10.255.248.76      2			<< VPN
			   10.50.12.5  255.255.255.255     10.255.248.1    10.255.248.76      2
			   10.50.13.5  255.255.255.255     10.255.248.1    10.255.248.76      2
			 10.255.248.0    255.255.254.0         On-link     10.255.248.76    257
			10.255.248.76  255.255.255.255         On-link     10.255.248.76    257
		   10.255.249.255  255.255.255.255         On-link     10.255.248.76    257
				127.0.0.0        255.0.0.0         On-link         127.0.0.1    306
				127.0.0.1  255.255.255.255         On-link         127.0.0.1    306
		  127.255.255.255  255.255.255.255         On-link         127.0.0.1    306
		....

	
		
	Due to the metric of the connection, a DNS lookup should always pick VPN. As long as the routing table is showing a lower metric 
	for the LAN connection than the VPN, it should be working the way you want.

	If you need to verify your metrics per connection, you should be able to look at the IP address in the interface column to get the corresponding metric. 
	Physical interfaces should have the same metric for all entries. Virtual interfaces (and loopback) will gave different metrics based on the physical 
	connection they are using for the given entry.

	1. To choose an interface as primary change metric as low as possible.
	For example in this case set metric of ethernet/wireless interface to 1.
	
	
	2. Or try to add DNS server and set the order.:
		If you want to ensure a specific order to the DNS servers, you can define a prefered order list at:
		
			INTERFACE/Properties>Internet Protocol(TCP/IP)/Properties/Advanced/[DNS]". 
			
		This list will need to be defined on each connection.	

	SEE ALSO:	
		How to Change the Priority of Network Cards in Windows.pdf

		
		
Usable commands/tools
---------------------
	ipconfig  /all
	ipconfig  /flushdns
	ipconfig  /displaydns
	nslookup <FQDN>
	
	