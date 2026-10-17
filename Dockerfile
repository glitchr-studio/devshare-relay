# iroh-relay, built from its published source: the relay DevShare's
# sessions use when a direct connection cannot be made.
FROM rust:1-bookworm AS build
RUN cargo install --locked iroh-relay@1.3.0 --features server --root /out

FROM debian:bookworm-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && rm -rf /var/lib/apt/lists/*
COPY --from=build /out/bin/iroh-relay /usr/local/bin/iroh-relay
ENTRYPOINT ["iroh-relay", "--config-path", "/etc/iroh-relay/relay.toml"]
