FROM ghcr.io/dockhippie/alpine:3.23@sha256:dd0a8a957cb409bde4a96e04af7b59b16f3436817784c67afb9b6bc431672e3e as build

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

FROM ghcr.io/dockhippie/alpine:3.23@sha256:dd0a8a957cb409bde4a96e04af7b59b16f3436817784c67afb9b6bc431672e3e
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /tmp/shellcheck /usr/bin/
