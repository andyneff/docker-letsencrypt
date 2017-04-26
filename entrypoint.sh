#!/usr/bin/env sh

set -eu

if [ "$1" == "crond" ]; then
  shift 1
  echo $((($(date '+%M')+1)%60)) $(date '+%H') '* * * /opt/certbot/bin/certbot renew' ${@+"${@}"} > /crontab.txt
  crontab /crontab.txt
  crond -l 7 -f -d
else
  exec "${@}"
fi