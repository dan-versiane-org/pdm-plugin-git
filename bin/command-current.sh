#!/usr/bin/env bash

handle::git:::current() {
  local result
  local GIT_PROJECTS_DIR="$(pdm::workspace::current_path)/projects"

  for i in $(ls ${GIT_PROJECTS_DIR}); do
    cd ${GIT_PROJECTS_DIR}/${i}
    local current=$(git branch --show-current)
    result="${result}"$'\n'"  ${PDM_PC}${i}|:${PDM_GC} ${current}${PDM_RC}"
  done

  echo -e "$result" | column -t -s "|"

  cd - >/dev/null 2>&1
}

handle::git:::current
