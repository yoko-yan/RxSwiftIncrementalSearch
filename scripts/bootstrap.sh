#!/bin/sh -x

# setup Gems, Brews and Mints
echo "Install Gems and Brew, Mint"
gem install bundler
bundle config set path 'vendor/bundle'
bundle install

git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core fetch --unshallow
git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask fetch --unshallow
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
