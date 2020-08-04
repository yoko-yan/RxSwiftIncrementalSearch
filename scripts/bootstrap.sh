#!/bin/sh -x

# setup Gems, Brews and Mints
echo "Install Gems and Brew, Mint"
gem install bundler
bundle install --path vendor/bundle
brew update
brew install mint
brew install libxml2
MINT_PATH=./mint/lib MINT_LINK_PATH=./mint/bin /usr/local/bin/mint bootstrap --link

# install CocoaPods
echo "Install CocoaPods"
bundle exec pod install

# install Carthage
echo "Install Carthage"
./mint/bin/carthage bootstrap --platform iOS --no-use-binaries --cache-builds

echo "Open Project!"

open RxSwiftIncrementalSearch.xcworkspace
