#!/bin/zsh
set -e

packages=(
  map-utilities
  plotvuer
  simulationvuer
  map-sidebar
  flatmapvuer
  scaffoldvuer
  mapintegratedvuer
  svg-sprite
)

for package in "${packages[@]}"; do
  cd "$package" || exit
  rm -rf node_modules
  rm -rf dist
  npm install
  npm run build-bundle
  cd - >/dev/null || exit
done
