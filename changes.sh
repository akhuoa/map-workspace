#!/bin/zsh

# Get today's commits since midnight in each repo under current directory

for dir in */; do
  # Check if directory is a git repo
  if [ -d "$dir/.git" ]; then
    # Check for commits since midnight
    commits=$(git -C "$dir" log --since=midnight --oneline)

    if [[ -n $commits ]]; then
      echo "Changes today in repo: \033[0;32m$dir\033[0m"
    fi
  fi
done
