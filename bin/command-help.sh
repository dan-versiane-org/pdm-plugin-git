#!/usr/bin/env bash

help::commands() {
  echo "$(pdm::show_command 'checkout' 'Switch to a different branch of projects.')"
  echo "$(pdm::show_command 'clone' 'Clone a git repo.')"
  echo "$(pdm::show_command 'current' 'Show the current branch of projects.')"
  echo "$(pdm::show_command 'help' 'Show plugin help.')"
  echo "$(pdm::show_command 'version' 'Show plugin version.')"
}

pdm::show_usage git
echo -e "$(help::commands)" | column -t -s "|"
