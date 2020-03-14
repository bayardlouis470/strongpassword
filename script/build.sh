#!/bin/bash

build_react() {
    echo 'building react'

    # react generate file name with hash
    # to make sure no deprecated files in dist
    rm -rf dist/*

    # chrome extension doesn't allow inline script
    export INLINE_RUNTIME_CHUNK=false
    # prevent generating sourcemap
    export GENERATE_SOURCEMAP=false

    # react-scripts build generate by default PRODUCTION build
    react-scripts build

    # copy from build to dist, build could still be used by 'npm run start'
    mkdir -p dist
    cp -r build/* dist
}

build_others() {
    echo 'building others'

#    webpack

    # background.js was already in dist by webpack
    cp src/background/background.js dist
    # content_blocker.js was already in dist by webpack
    # cp src/content/content_blocker.js dist

    cp src/background/background.html dist
#    cp src/background/firebase*.js dist
#    cp src/background/api.js dist
    mv dist/index.html dist/popup.html
    cp dist/popup.html dist/options.html
    cp public/manifest.json dist/manifest.json

    cp -r public/images dist
    rm dist/images/*.xd
}

if [ $# -eq 0 ]; then
    echo 'build react|others'
fi

case $1 in
'react')
    build_react
    ;;
'others')
    build_others
    ;;
esac
