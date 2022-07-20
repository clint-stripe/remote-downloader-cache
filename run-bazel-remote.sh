#!/bin/bash

set -euxo pipefail

# needed to download the prebuilt bazel-remote binary
# e.g. bazel-remote-2.3.8-darwin-x86_64
os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"

mkdir -p tmp

bazelremote="tmp/bazel-remote"
if [ ! -x "$bazelremote" ]; then
    wget "https://github.com/buchgr/bazel-remote/releases/download/v2.3.8/bazel-remote-2.3.8-${os}-${arch}" -O "$bazelremote"
    chmod +x "$bazelremote"
fi

mkdir -p tmp/cache
mkdir -p tmp/repo_cache
mkdir -p tmp/disk_cache
"$bazelremote" --config_file bazelremote_config.yaml &
bazelremote_pid=$!
function cleanup() {
    kill $bazelremote_pid
    rm -rf tmp/cache tmp/repo_cache tmp/disk_cache
}
trap "cleanup" EXIT

wait