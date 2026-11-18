#!/bin/bash
# land's environment for entire-cli: Go as pinned in mise.toml and go.mod, every module downloaded now, because the
# tests run offline as a normal user. land runs this once as root on plain Debian (git and python3 only).
set -e
[ -f go.mod ] || exit 0
apt-get update -qq && apt-get install -y -qq --no-install-recommends ca-certificates curl git >/dev/null
GO_VERSION=$(sed -n 's/^go \([0-9.]*\).*/\1/p' go.mod)
curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | tar -xz -C /usr/local
ln -sf /usr/local/go/bin/go /usr/local/bin/go
export GOMODCACHE=/opt/gomodcache GOTOOLCHAIN=local
go mod download
chmod -R a+rX /opt/gomodcache
