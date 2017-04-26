[letsencrypt]: https://letsencrypt.org/

[![letsencrypt](https://github.com/letsencrypt/website/raw/master/images/le-logo-wide.png)][letsencrypt]

## Usage

For the first time (or to add additional domains)

```bash
docker-compose run --service-ports letsencrypt certonly --standalone --email <email> -d <URL> ...
```

For a non-interactive run the first time

```bash
docker-compose run --service-ports letsencrypt certonly --standalone --agree-tos \
  --no-eff-email --email <email> -d <URL> ...
```

All certbot commands can be executed with `docker-compose run letsencrypt`

---

To start the daemon to continue renewing, run

```bash
docker-compose -f docker-compose.yml up -d
```

## Customize

The .env file contains the following settings:

- `HTTPS_PORT` - Default 443. If you need to use a port other than 443 on the 
host, change this. However your router/network must make it port 443 by the 
time it hits the internet, or else letsencrypt won't work
