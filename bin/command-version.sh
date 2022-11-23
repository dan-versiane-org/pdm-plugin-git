#!/usr/bin/env bash

handle::git::version() {
  printf "%s\\n" "$(cat ${PDM_DIR}/plugins/git/version.md)"
}

handle::git::version
