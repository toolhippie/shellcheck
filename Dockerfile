FROM webhippie/alpine:3.15 as build

# renovate: datasource=github-releases depName=koalaman/shellcheck
ENV SHELLCHECK_VERSION=0.8.0

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

FROM webhippie/alpine:3.15
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /tmp/shellcheck /usr/bin/
