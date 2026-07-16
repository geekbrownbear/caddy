# Custom build of caddy-docker-proxy with the Cloudflare DNS module added,
# so ACME can use the DNS-01 challenge (needed for internal-only hostnames
# that are never publicly resolvable, e.g. *.local.bearium.net).
#
# Check your currently-running Caddy version before changing this:
#   docker exec caddy-proxy caddy version
ARG CADDY_VERSION=2.9.1
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:${CADDY_VERSION}-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
CMD ["caddy", "docker-proxy"]
