REM Configure this (begin)


set AUTH_EMAIL=example@example.com
set AUTH_KEY=** CF Authorization  key **
set ZONE_ID=** CF Zone ID **
set A_RECORD_NAME="dynamic"
set A_RECORD_ID=** CF A-record ID from cloudflare-dns-id.sh **

REM Configure this (end)


set IP_RECORD=%USERPROFILE%\AppData\Local\last_ip

for /F %%I in ('curl --silent https://api.ipify.org') do set PUBLIC_IP=%%I
echo %PUBLIC_IP%

REM Retrieve the last recorded public IP address

set /p RECORDED_IP=<%IP_RECORD%

echo %RECORDED_IP%

REM If the public ip has not changed, nothing needs to be done, exit.

if "%PUBLIC_IP%" == "%RECORDED_IP%" pause

echo %PUBLIC_IP%> %IP_RECORD%

SET RECORD= {  \"type\":  \"A\",^
   \"name\":  \"%A_RECORD_NAME%\",^
   \"content\":  \"%PUBLIC_IP%\",^
   \"ttl\":  1,^
   \"proxied\": false }

REM echo %myFlags%

curl "https://api.cloudflare.com/client/v4/zones/%ZONE_ID%/dns_records/%A_RECORD_ID%" -X PUT -H "Content-Type: application/json"  -H "X-Auth-Email: %AUTH_EMAIL%"  -H "X-Auth-Key: %AUTH_KEY%"  -d "%RECORD%"
