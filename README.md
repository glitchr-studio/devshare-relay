# A relay for DevShare

DevShare connects your guests to your Mac directly when it can. When their
networks don't allow it (mobile data, company firewalls), both sides connect
out to a relay, which passes the encrypted traffic between them. The relay
cannot read it.

By default DevShare uses the free public relays of [iroh](https://www.iroh.computer).
This repository runs a relay of your own: for an organisation whose firewall
only lets approved sites through, or to depend on no one else.

## What you need

- A machine reachable from the internet (a small cloud server is enough),
  with Docker.
- A domain name pointing to it, for example `relay.example.com`.
- Ports **80** and **443** (TCP) and **7842** (UDP) open to the internet.

## Run it

```sh
git clone https://github.com/glitchr-studio/devshare-relay
cd devshare-relay
# In relay.toml, set hostname to your domain and contact to your email.
docker compose up -d
```

The relay obtains its HTTPS certificate from Let's Encrypt by itself.

## Use it

In DevShare on your Mac: **Settings → General → Relay**, enter
`https://relay.example.com`, then press **Test** under **This computer**.
Your guests need nothing: each invitation carries the relay to use.

## Try it on one machine first

`relay.local.toml` runs the relay over plain HTTP on port 3340, without a
domain or a certificate. For a trial on your own machine only:

```sh
docker build -t devshare-relay .
docker run --rm -p 127.0.0.1:3340:3340 \
  -v "$PWD/relay.local.toml:/etc/iroh-relay/relay.toml:ro" devshare-relay
```

Then enter `http://127.0.0.1:3340` as the relay and press Test.

## Limits

`relay.toml` holds each client to 2 MiB/s (bursts of 8 MiB) and new
connections to 20 a second: enough for sharing development sites, and a
guard against a relay used for anything else. Adjust them there.
