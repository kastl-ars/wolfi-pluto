######################################################
######################################################
######################################################
FROM quay.io/curl/curl-base:8.8.0 as builder

ARG PLUTO_VERSION

#
# download pluto
#
WORKDIR /
RUN curl -L --silent -o pluto_${PLUTO_VERSION/v/}_linux_amd64.tar.gz https://github.com/FairwindsOps/pluto/releases/download/${PLUTO_VERSION}/pluto_${PLUTO_VERSION/v/}_linux_amd64.tar.gz && \
    tar xvf pluto_${PLUTO_VERSION/v/}_linux_amd64.tar.gz

######################################################
######################################################
######################################################
FROM cgr.dev/chainguard/wolfi-base:latest

USER root
WORKDIR /usr/bin/
COPY --from=builder /pluto /usr/bin/pluto
RUN chmod +x /usr/bin/pluto

# finished building
WORKDIR /
USER nobody
ENTRYPOINT ["/usr/bin/pluto"]

LABEL org.opencontainers.image.authors="Johannes Kastl" \
      org.opencontainers.image.title="pluto" \
      org.opencontainers.image.description="Pluto is a cli tool to help discover deprecated apiVersions in Kubernetes" \
      org.opencontainers.image.documentation="https://pluto.docs.fairwinds.com/" \
      org.opencontainers.image.source="https://github.com/kastl-ars/wolfi-pluto" \
      org.opencontainers.image.url="https://github.com/kastl-ars/wolfi-pluto" \
      org.opencontainers.image.licenses="Apache License 2.0"
