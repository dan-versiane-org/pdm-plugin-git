#!/usr/bin/env bash

GIT_REPO_FILE="$(pdm::workspace::current_path)/config/pdm/repository.config"
GIT_PROJECTS_DIR="$(pdm::workspace::current_path)/projects"

handle::git::clone_one() {
  local REPO_URL="$2"
  local PROJECT_FULL_DIR="${GIT_PROJECTS_DIR}/${1}"

  if [ -d $PROJECT_FULL_DIR ]; then
    # pdm::warn "Directory $PROJECT_FULL_DIR already exists."
    return
  fi

  if [ -z $DEFAULT_BRANCH ]; then
    git clone "$REPO_URL" "$PROJECT_FULL_DIR" || {
      pdm::error "Failed to clone ${1}"
      exit 1
    }
  else
    git clone --branch="$DEFAULT_BRANCH" "$REPO_URL" "$PROJECT_FULL_DIR" || {
      pdm::error "Failed to clone ${1}"
      exit 1
    }
  fi
}

handle::git::clone_all() {
  while read PROJECT; do
    local RESULT=()

    IFS=";" read -a RESULT <<< "$PROJECT"

    handle::git::clone_one "${RESULT[0]}" "${RESULT[1]}"
  done < ${GIT_REPO_FILE}
}

handle::git::clone() {
  local git_message_error

  if [ ! -f $GIT_REPO_FILE ]; then
    git_message_error="Cannot find file ${PDM_PC}'$GIT_REPO_FILE'${PDM_RC}."
  elif [ ! -s "$GIT_REPO_FILE" ]; then
    git_message_error="No projects found on repository config."
  fi

  if [ -n "$git_message_error" ]; then
    pdm::error "$git_message_error"$'\n'
    pdm::echo " ${PDM_TC}Example:${PDM_RC}"
    pdm::echo "   project-name;github.com:any_user_git/project-url.git"$'\n'
    exit 1
  fi

  if [ -z $1 ]; then
    handle::git::clone_all
  else
    while read PROJECT; do
      local RESULT=()

      IFS=";" read -a RESULT <<< "$PROJECT"

      if [ "${1}" == "${RESULT[0]}" ]; then
        handle::git::clone_one "${RESULT[0]}" "${RESULT[1]}"
        exit 0
      fi
    done < $GIT_REPO_FILE

    pdm::error "Project ${1} not found on config repo."
    exit 1
  fi

  pdm::success "Clone successful."
}

handle::git::clone ${@}
unset GIT_REPO_FILE GIT_PROJECTS_DIR
