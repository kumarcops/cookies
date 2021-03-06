#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

[ $# -eq 1 ] && grep -qE '^\d+\.\d+\.\d+$' <<<"$1" || {
  echo "usage: $0 <semantic-version>" >&2
  exit 2
}

set -x

tag="v$1"

export GOOS=darwin
export GOARCH=amd64
./build.sh
archive="cookies_${tag}_${GOOS}_${GOARCH}.gz"
gzip --stdout cookies >"${archive}"
hub release create -d -a "${archive}" -m "${tag}" "${tag}"
