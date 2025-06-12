#!/bin/zsh
# iterates over all subdirectories in the current directory
# for each subdirectory that is a Git repository,
# prints the directory name
# and the current Git branch (in green)

for dir in */; do
  if [ -d "$dir/.git" ]; then
    branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
    echo "$dir: \033[0;32m$branch\033[0m"
  fi
done
