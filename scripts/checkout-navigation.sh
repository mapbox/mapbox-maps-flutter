#!/usr/bin/env bash

git clone --no-checkout https://github.com/mapbox/mapbox-navigation-ios.git ./ios/Classes/Navigation

cd ./ios/Classes/Navigation

git tag

git checkout tags/v3.5.0