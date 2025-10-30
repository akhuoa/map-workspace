#!/bin/zsh
# git pull for all repos

# Iterate over all directories in the current directory
for dir in */; do
  # Check if the directory is a Git repository
  if [[ -d "$dir/.git" ]]; then
    echo "Entering '$dir'..."
    cd "$dir" || exit

    # Check if the working directory is clean
    if ! git diff-index --quiet HEAD --; then
      echo "\033[31mError: Working directory not clean in '$dir'. Please commit or stash changes before pulling.\033[0m"
      cd - > /dev/null || exit
      continue
    fi

    # Pull the latest changes
    echo "Pulling latest changes in '$dir'..."
    if ! git pull; then
      echo "\033[31mError: Failed to pull changes in '$dir'.\033[0m"
      cd - > /dev/null || exit
      continue
    fi
    echo "Successfully pulled latest changes in '$dir'."

    # Return to the parent directory
    cd - > /dev/null || exit
  else
    echo "'$dir' is not a Git repository. Skipping..."
  fi

  echo "\n"
done

echo "All repositories updated successfully."
