FROM webhippie/alpine:latest AS build

ENV SHELLCHECK_VERSION v0.5.0
ENV SHELLCHECK_DOWNLOAD https://github.com/koalaman/shellcheck/archive/${SHELLCHECK_VERSION}.tar.gz

RUN apk update && \
  apk add git cabal ghc musl-dev && \
  curl -sLo - ${SHELLCHECK_DOWNLOAD} | tar -xzf - --strip 1 -C /tmp

RUN cd /tmp && \
  cabal update && \
  cabal install --dependencies-only && \
  cabal build Paths_ShellCheck && \
  ghc -optl-static -optl-pthread -isrc -idist/build/autogen --make shellcheck && \
  strip --strip-all shellcheck

FROM webhippie/alpine:latest

LABEL maintainer="Thomas Boerger <thomas@webhippie.de>" \
  org.label-schema.name="Shellcheck" \
  org.label-schema.vendor="Thomas Boerger" \
  org.label-schema.schema-version="1.0"

ENTRYPOINT ["/usr/bin/shellcheck"]

RUN apk update && \
  apk upgrade && \
  apk add make && \
  rm -rf /var/cache/apk/*

COPY --from=build /tmp/shellcheck /usr/bin/
