#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/cantino/mcfly"
TOOL_NAME="mcfly"
TOOL_TEST="mcfly --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local platform
  case "$OSTYPE" in
    darwin*) platform="apple-darwin" ;;
    linux*) platform="unknown-linux-musl" ;;
    *) fail "Unsupported platform" ;;
  esac

  local architecture
  case "$(uname -m)" in
    i686) architecture="i686" ;;
    x86_64) architecture="x86_64" ;;
    arm64) architecture="armv7" ;;
    *) fail "Unsupported architecture" ;;
  esac

  if [[ "${architecture}" == "armv7" && "$OSTYPE" == "linux" ]]; then
    platform="unknown-linux-gnueabihf"
  fi

  url="$GH_REPO/releases/download/v${version}/mcfly-v${version}-${architecture}-${platform}.tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  local release_file="$install_path/$TOOL_NAME-$version.tar.gz"
  (
    mkdir -p "$install_path"
    download_release "$version" "$release_file"
    tar -zxf "$release_file" -C "$install_path" || fail "Could not extract $release_file"
    rm "$release_file"

    local tool_cmd
    mkdir "$install_path/bin"
    mv "$install_path/mcfly" "$install_path/bin/mcfly"
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
