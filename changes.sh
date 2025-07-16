#!/bin/zsh

# Usage: ./changes.sh [days_ago]
# days_ago: 0 (default) = today, 1 = today + yesterday, 2 = today + yesterday + day before, etc.

days_ago=${1:-0}

if [[ $days_ago -eq 0 ]]; then
  since="midnight"
else
  since="$(date -v -${days_ago}d +%Y-%m-%d) 00:00"
fi

for dir in */; do
  if [ -d "$dir/.git" ]; then
    commits=$(git -C "$dir" log --since="$since" --oneline)
    if [[ -n $commits ]]; then
      echo "Changes in last $((days_ago+1)) day(s) in repo: \033[0;32m$dir\033[0m"
      # Print each commit in yellow with a bullet
      echo "$commits" | while IFS= read -r line; do
        echo "  \033[0;33m• $line\033[0m"
      done
    fi
  fi
done
