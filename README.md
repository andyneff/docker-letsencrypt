[letsencrypt]: https://letsencrypt.org/

[![letsencrypt](https://raw.githubusercontent.com/letsencrypt/website/dba3d7067c54a6f25f5f9f1cd3e7886edfb77ad1/static/images/le-logo-wide.png)][letsencrypt]

## Usage

*Development trick*: Always add `--staging` to all commands to use the fake
Let's Encrypt test server, until you have everything working. This could save
you from hitting rate limits, and potentially making you wait a week for them
to reset.

For the first time (or to add additional domains)

```bash
docker-compose run --service-ports letsencrypt certonly --standalone --email <email> -d <URL> ...
```

For a non-interactive run the first time

```bash
docker-compose run --service-ports letsencrypt certonly --standalone --agree-tos \
  --no-eff-email --email <email> -d <URL> ...
```

All certbot commands can be executed with `docker-compose run letsencrypt`, for
example `docker-compose run --service-ports letsencrypt renew --force-renewal`

---

To start the daemon to continue renewing, run

```bash
docker-compose -f docker-compose.yml up -d
```

And assuming nothing breaks, the service should run forever. It will resume on
docker restarts/upgrades and computer reboot.

## Manual renewal

Sometimes, a certificate or gateway proxy will be forgotten and the certificate
will expire and no longer work. This can make renewing using the tls-sni-01
challenge... challenging. Instead of starting over, reconfiguring your network,
here are a few trick to get your certificate working again:

1. Don't forget `--staging` until you get everything working. If you have a
   near expired valid cert, you will need to add the `--dry-run` or
   `--break-my-certs` flag. I suggest always using `--dry-run` with staging, or
   else your setting will become permanently set for staging.
2. `--authenticator standalone`. If you used another authenticator (such as
   webroot) in the initial key setup, you will need to override this once until
   the key is functioning again.
3. `--preferred-challenges http-01`. If the gateway has an out of date ssl cert,
   or doesn't even use ssl, this will force it to use http only for the
   challenge. Other options at this time are: tls-sni-01 (default), http-01, and
   dns-01 (not supported by standalone)

Upon successful test, these values will be written to the renewal configuration.
To change them back, run a `--force-renew` with them set back to how you want
them.

## Customize

The .env file contains the following settings:

- `HTTPS_PORT` - Default 443. If you need to use a port other than 443 on the
host, change this. However your router/network must make it port 443 by the
time it hits the internet, or else letsencrypt won't work
