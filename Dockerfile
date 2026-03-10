FROM ghcr.io/dockhippie/alpine:3.23@sha256:a487d822b211f6a58d975eb01a2896d8f18258e676008cb83ef80e5ad3ba2c1f as build

# renovate: datasource=github-releases depName=koalaman/shellcheck
ENV SHELLCHECK_VERSION=0.11.0

ARG TARGETARCH

RUN apk add -U xz && \
  case "${TARGETARCH}" in \
		'amd64') \
			curl -sSLo- https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz | tar -xJv --strip 1 -C /tmp; \
			;; \
		'arm64') \
			curl -sSLo- https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.aarch64.tar.xz | tar -xJv --strip 1 -C /tmp; \
			;; \
		'arm') \
			curl -sSLo- https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.armv6hf.tar.xz | tar -xJv --strip 1 -C /tmp; \
			;; \
		*) echo >&2 "error: unsupported architecture '${TARGETARCH}'"; exit 1 ;; \
	esac

FROM ghcr.io/dockhippie/alpine:3.23@sha256:a487d822b211f6a58d975eb01a2896d8f18258e676008cb83ef80e5ad3ba2c1f
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /tmp/shellcheck /usr/bin/
