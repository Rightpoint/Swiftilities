#!/usr/bin/env bash

source ~/.rvm/scripts/rvm
rvm use default
bundle install --jobs=3 --retry=3 --deployment
bundle exec pod trunk push
