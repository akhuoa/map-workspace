#!/bin/zsh
# build bundle for all packages
# and link them together
# and generate tgz package for mapintegratedvuer

# svg sprite
cd ./svg-sprite || exit
echo 'Updating svg-sprite ...'
npm install
npm run build-bundle
cd - || exit

# map utilities
cd ./map-utilities || exit
echo 'Updating map-utilities ...'
npm install
npm link ../svg-sprite
npm run build-bundle
cd - || exit

# Navigate to plotvuer directory, and build plotvuer
cd ./plotvuer || exit
echo 'Updating plotvuer ...'
npm install
npm link ../svg-sprite
npm run build-bundle
cd - || exit

# Navigate to simulationvuer directory, link plotvuer, and exit
cd ./simulationvuer || exit
echo 'Updating simulationvuer ...'
npm install
npm link ../plotvuer
npm run build-bundle
cd - || exit

# Navigate to map-sidebar directory, link map-utilities, and exit
cd ./map-sidebar || exit
echo 'Updating map-sidebar ...'
npm install
npm link ../svg-sprite ../map-utilities
npm run build-bundle
cd - || exit

# Navigate to flatmapvuer directory, link map-utilities, and exit
cd ./flatmapvuer || exit
echo 'Updating flatmapvuer ...'
npm install
npm link ../svg-sprite ../map-utilities
npm run build-bundle
cd - || exit

# Navigate to scaffoldvuer directory, link map-utilities, and exit
cd ./scaffoldvuer || exit
echo 'Updating scaffoldvuer ...'
npm install
npm link ../svg-sprite ../map-utilities
npm run build-bundle
cd - || exit

# Navigate to mapintegratedvuer directory, link map-utilities, plotvuer, map-sidebar, and flatmapvuer, and simulationvuer, and exit
cd ./mapintegratedvuer || exit
echo 'Updating mapintegratedvuer ...'
npm install
npm link ../svg-sprite ../map-utilities ../plotvuer ../map-sidebar ../flatmapvuer ../simulationvuer
npm run build-bundle
# generate tgz package for mapintegratedvuer
npm pack
echo 'Generated tgz package for mapintegratedvuer'
cd - || exit
