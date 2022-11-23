#!/usr/bin/env bash

handle::git::checkout() {
  local branch=$1
  local git_params=""
  local is_new_branch=""
  local only_checkout=0
  local GIT_PROJECTS_DIR="$(pdm::workspace::current_path)/projects"

  for ARG in ${@:2:$#}; do
    case "${ARG}" in
      -f|--force) git_params="$git_params -f";;
      -b) is_new_branch="-b";;
      -o|--only-checkout) only_checkout=1;;
    esac
  done

  for i in $(ls ${GIT_PROJECTS_DIR}); do
    cd ${GIT_PROJECTS_DIR}/${i}

    local current=$(git branch --show-current)
    pdm::echo "  * ${PDM_PC}${i}: ${PDM_GC}${current}${PDM_RC} -> ${PDM_GC}${branch}${PDM_RC}"

    if [ $only_checkout -eq 1 ]; then
      git checkout -q ${is_new_branch} ${branch} ${git_params} 2>/dev/null || {
        pdm::error "Failed to checkout ${PDM_PC}${i}${PDM_RC} to ${PDM_PC}${1}${PDM_RC}"
        continue
      }
    else
      if [ "$current" != "$branch" ]; then
        git fetch origin --prune 2>/dev/null
        git checkout -q ${is_new_branch} ${branch} ${git_params} 2>/dev/null || {
          pdm::error "Failed to checkout ${PDM_PC}${i}${PDM_RC} to ${PDM_PC}${1}${PDM_RC}"
          continue
        }
      fi

      git pull origin "${branch}" 2>/dev/null || {
        pdm::error "Failed to pull ${PDM_PC}${i}${PDM_RC} -> ${PDM_PC}${1}${PDM_RC}"
        continue
      }
    fi
  done

  cd - >/dev/null 2>&1
}

handle::git::checkout ${@}
