FROM ghcr.io/dockhippie/alpine:3.23@sha256:ecf1af2fb0a1dd8a7c5db631a254ac3b77fcb53c51b18ab7bc8548699afad289 as build

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

FROM ghcr.io/dockhippie/alpine:3.23@sha256:ecf1af2fb0a1dd8a7c5db631a254ac3b77fcb53c51b18ab7bc8548699afad289
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /tmp/shellcheck /usr/bin/
