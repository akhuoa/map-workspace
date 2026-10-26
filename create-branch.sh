#!/bin/zsh
# For each Git repository in the subdirectories:
#  - if the given branch exists (locally or on origin), switch to it
#  - otherwise create it from "main"
# Afterwards, report which pre-existing branches are behind "main".
# Usage: ./create-branch.sh [branch-name]

branch="$1"
if [[ -z "$branch" ]]; then
  echo -n "Enter the branch name: "
  read branch
fi

if [[ -z "$branch" ]]; then
  echo "\033[31mError: No branch name provided.\033[0m"
  exit 1
fi

existing=()
created=()
failed=()

for dir in */; do
  dir=${dir%/}
  [[ -e "$dir/.git" ]] || continue

  echo "Repo: \033[1m$dir\033[0m"

  if [[ -n $(git -C "$dir" status --porcelain) ]]; then
    echo "  \033[31mWorking directory not clean. Skipping.\033[0m\n"
    failed+=("$dir")
    continue
  fi

  git -C "$dir" fetch origin --quiet 2>/dev/null

  if git -C "$dir" show-ref --verify --quiet "refs/heads/$branch"; then
    echo "  Branch '$branch' exists locally. Switching..."
    git -C "$dir" checkout --quiet "$branch" && existing+=("$dir") || failed+=("$dir")
  elif git -C "$dir" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    echo "  Branch '$branch' exists on origin. Switching..."
    git -C "$dir" checkout --quiet -b "$branch" --track "origin/$branch" && existing+=("$dir") || failed+=("$dir")
  else
    if git -C "$dir" show-ref --verify --quiet "refs/remotes/origin/main"; then
      base="origin/main"
    elif git -C "$dir" show-ref --verify --quiet "refs/heads/main"; then
      base="main"
    else
      echo "  \033[31mNo 'main' branch found. Skipping.\033[0m\n"
      failed+=("$dir")
      continue
    fi
    echo "  Branch '$branch' does not exist. Creating from '$base'..."
    git -C "$dir" checkout --quiet -b "$branch" --no-track "$base" && created+=("$dir") || failed+=("$dir")
  fi
  echo ""
done

echo "========== Summary =========="
for d in $created; do echo "\033[0;32mCreated\033[0m  $d -> $branch"; done
for d in $existing; do echo "\033[0;34mSwitched\033[0m $d -> $branch"; done
for d in $failed; do echo "\033[31mFailed\033[0m   $d"; done

echo "\n===== Status of existing branches vs main ====="
if (( ${#existing} == 0 )); then
  echo "No pre-existing branches to check."
fi
for d in $existing; do
  if git -C "$d" show-ref --verify --quiet "refs/remotes/origin/main"; then
    base="origin/main"
  else
    base="main"
  fi
  behind=$(git -C "$d" rev-list --count "HEAD..$base" 2>/dev/null)
  ahead=$(git -C "$d" rev-list --count "$base..HEAD" 2>/dev/null)
  if [[ "$behind" == "0" ]]; then
    echo "$d: \033[0;32mup to date with $base\033[0m (ahead $ahead)"
  else
    echo "$d: \033[0;33moutdated - behind $base by $behind commit(s)\033[0m (ahead $ahead)"
  fi
done
