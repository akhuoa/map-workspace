#!/bin/zsh
set -e

packages=(
  mapcore-gallery
  svg-sprite
  plotvuer
  map-utilities
  map-sidebar
  simulationvuer
  scaffoldvuer
  flatmapvuer
  mapintegratedvuer
)

for package in "${packages[@]}"; do
  cd "$package" || exit
  rm -rf node_modules
  rm -rf dist
  npm install
  npm run build-bundle
  cd - >/dev/null || exit
done
