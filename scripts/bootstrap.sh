#!/bin/sh -x

# setup Gems, Brews and Mints
echo "Install Gems and Brew, Mint"
gem install bundler
bundle install --path vendor/bundle
brew update
brew install mint
make mint-bootstrap

# install CocoaPods
echo "Install CocoaPods"
bundle exec pod install

# install Carthage
echo "Install Carthage"
make carthage-bootstrap

echo "Open Project!"

open RxSwiftIncrementalSearch.xcworkspace
