#!/bin/zsh

# map utilities
cd ./map-utilities || exit
echo 'Updating map-utilities ...'
npm i
npm run build-bundle
cd - || exit

# Navigate to map-sidebar directory, link map-utilities, and exit
cd ./map-sidebar || exit
echo 'Updating map-sidebar ...'
npm i
npm link ../map-utilities
npm run build-bundle
npm run test
cd - || exit

# Navigate to flatmapvuer directory, link map-utilities, and exit
cd ./flatmapvuer || exit
echo 'Updating flatmapvuer ...'
npm i
npm link ../map-utilities
npm run build-bundle
npm run cypress:component
cd - || exit

# Navigate to scaffoldvuer directory, link map-utilities, and exit
cd ./scaffoldvuer || exit
echo 'Updating scaffoldvuer ...'
npm i
npm link ../map-utilities
npm run build-bundle
# npm run test # Scaffold doesn't have test yet
cd - || exit

# Navigate to mapintegratedvuer directory, link map-utilities, map-sidebar, and flatmapvuer, and exit
cd ./mapintegratedvuer || exit
echo 'Updating mapintegratedvuer ...'
npm i
npm link ../map-utilities ../map-sidebar ../flatmapvuer
npm run build-bundle
npm run cypress-component
cd - || exit
