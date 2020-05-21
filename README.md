![alt text](https://raw.githubusercontent.com/dcerisano/cloudflare-dynamic-dns/master/img/cloudflare-dns.png)

Cloudflare DDNS curl scripts that call CF-API (v4) ***directly***.

My third-party DDNS service stopped working recently with CF.
It seems CF has moved to a new API (v4).

The very good news is you can ditch third-party DDNS and simply run a DDNS shell script as a cron job every minute on your webserver. It calls the new CF API ***directly***.

This is a bare bones script that requires:
* Internet connectivity is available.
* CF API v4 service  is available
* api.ipify.org service is available

To get started, copy config.sample to config and fill in the fields

**Prerequisites**

The script requires [jq](https://stedolan.github.io/jq/download/) to parse the Cloudflare API JSON. Install for your system, e.g.: `sudo apt-get install jq` (Ubuntu/Debian) or `brew install jq` (MacOS). Or download the binary directly from https://stedolan.github.io/jq/download/

**Run** To update your DNS, run [cloudflare-ddns.sh](https://raw.githubusercontent.com/dcerisano/cloudflare-dynamic-dns/master/cloudflare-ddns.sh). It can also be set up to run as a cron job, e.g. `* * * * *    /.../cloudflare-ddns.sh`

**Test** by changing your A-record to a bogus IP and then deleting `/tmp/ip-record`
The cron job will change the A-record to your webserver IP address on it's next run.

**Marvel** at your own dynamic dns service - no more surrendering your CF Authorization key to a third party DDNS service.

**Note** that the CNAME alias masks your real IP address - a fundamental advantage of CF. Naming the A-record directly as your domain (example.com) would allow anyone to see your real IP address just by `ping example.com`. Try it!

**Note** that you will need to update this script:
* if your CF Zone ID, Authorization key, or A-record ID change. Only you can change these.
* if CF API v4 is deprecated. It is currently new, so should be stable for many years.
* if api.ipify.org is deprecated. There are many others. Or use `dig` if you like.

**Tested On**
MacOS 10.14+
