#!/bin/zsh
# A script to switch branches in multiple git repositories based on a JSON configuration file.

# Path to the JSON file
PROJECTS_FILE="projects.json"

# Check if the JSON file exists
if [[ ! -f "$PROJECTS_FILE" ]]; then
  echo "\033[31mError: '$PROJECTS_FILE' not found.\033[0m"
  exit 1
fi

# Read the JSON file
projects=$(cat "$PROJECTS_FILE")

# Check if a project name is provided
if [[ -z "$1" ]]; then
  echo "Select a project:"
  echo "$projects" | jq -r '.[] | .project' | nl -w2 -s'. '

  echo -n "Enter the number of the project: "
  read selection

  project_name=$(echo "$projects" | jq -r ".[$((selection - 1))].project" 2>/dev/null)
else
  project_name="$1"
fi

# Find the project configuration
project_config=$(echo "$projects" | jq -r ".[] | select(.project == \"$project_name\")")

# echo "Project config is: $project_config"

if [[ -z "$project_config" ]]; then
  echo "\033[31mError: Project '$project_name' not found.\033[0m"
  exit 1
fi

# Iterate over each repo and switch branches
echo "$project_config" | jq -c '.repos[]' | while IFS= read -r repo; do
  id=$(echo "$repo" | jq -r '.id')
  branch=$(echo "$repo" | jq -r '.branch')

  if [[ -d "$id" ]]; then
    cd "$id" || exit

    echo "Repo: $id\n"

    # Check if the working directory is clean
    if [[ -n $(git status --porcelain) ]]; then
      echo "\033[31mError: Working directory not clean in '$id'. Please commit, stash changes, or remove untracked files.\033[0m"
      cd - > /dev/null || exit
      continue
    fi

    # Checkout the branch
    if git show-ref --verify --quiet "refs/heads/$branch"; then
      echo "Branch '$branch' exists locally."
      git checkout "$branch" || exit
    else
      echo "Branch '$branch' does not exist locally. Fetching from origin..."
      git fetch origin "$branch"
      git checkout "$branch" || exit
    fi
    echo "Switched to branch '$branch' in '$id'."

    cd - > /dev/null || exit
  else
    echo "\033[31mError: Directory '$id' not found.\033[0m"
  fi

  echo "\n"
done

echo "All repositories switched successfully."
