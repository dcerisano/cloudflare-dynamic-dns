![alt text](https://raw.githubusercontent.com/dcerisano/cloudflare-dynamic-dns/master/img/cloudflare-dns.png)

Cloudflare bash DDNS scripts using CF-API v4 ***directly***. Ditch your third-party DDNS service! 

My dns-o-matic account stopped working recently with ddclient.
It seems CF has moved to a new API (v4).

The very good news is you can dump dns-o-matic and ddclient and simply run a DDNS shell script as a cron job every minute on your webserver. It calls the new CF API ***directly***.

This is a bare bones script that requires:
* You have internet connectivity.
* CF API v4 service  is available
* api.ipify.org service is available

You need the Zone ID,  Authorization key and A-record ID for your domain.

**Fetch** the first two  from your CF account.

**Create** the A-record in CF named "dynamic".

**Create** the CNAME alias (example.com --> dynamic.example.com) 

![alt text](https://raw.githubusercontent.com/dcerisano/cloudflare-dynamic-dns/master/img/cf.png)

**Fetch** The A-record ID with [cloudflare-dns-id.sh](https://raw.githubusercontent.com/dcerisano/cloudflare-dynamic-dns/master/cloudflare-dns-id.sh)

**Run** [cloudflare-ddns.sh](https://raw.githubusercontent.com/dcerisano/cloudflare-dynamic-dns/master/cloudflare-ddns.sh) as a cron job (as the user which runs the webserver - not root)

**Test** by changing your A-record to a bogus IP and then deleting `/tmp/prev_ip`
The cron job will change the A-record to your webserver IP address on it's next run.
(Configure cron job to run the script once every minute for best results - CF updates instantly)

**Marvel** at your own dynamic dns service - no more surrendering your CF Authorization key to someone else's service that can break whenever the CF API is upgraded. 

**Note** that the CNAME alias masks your real IP address - a fundamental advantage of CF. Setting the A-record directly to your domain (example.com) would allow anyone to see your real IP address just by `ping example.com`. Try it!

**Note** that you will need to update this script:
* If your CF Zone ID, Authorization key, or A-record ID change. Only you can change these.
* If CF API v4 is deprecated. It is currently new, so should be stable for many years.
* If api.ipify.org is deprecated. There are many others. Or use `dig` if you like.

|![alt text](https://raw.githubusercontent.com/dcerisano/cloudflare-dynamic-dns/master/img/dragon-key.png)|
**DO NOT** commit your Authorization key to GitHub - thar be dragons. If you did, **purge** the commit(s) and **change** your Authorization key.| 
