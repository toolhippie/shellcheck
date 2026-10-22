FROM ghcr.io/dockhippie/alpine:3.23@sha256:0518a97b1c6406d9777d435432dcb525b4f47a84562e13a6472f55ac6623f9f6 as build

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

FROM ghcr.io/dockhippie/alpine:3.23@sha256:0518a97b1c6406d9777d435432dcb525b4f47a84562e13a6472f55ac6623f9f6
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /tmp/shellcheck /usr/bin/
