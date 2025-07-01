#!/usr/bin/env bash

# Exit on error
set -o errexit

# Install gems
bundle install

# Run database migrations
bundle exec rails db:migrate

# Precompile assets
bundle exec rails assets:precompile
