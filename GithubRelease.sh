#!/bin/bash

if [[ -z $(git config --get user.email) ||  $(git config --get user.email) == "you@example.com" ]]
then
    echo "user.email is not set. Please run \`git config --global user.email \"you@example.com\"\` with your github account email." 
    exit 1
fi 

if [[ -z $(git config --get user.name) || $(git config --get user.name) == "Your name" ]]
then
    echo "user.name is not set. Please run \`git config --global user.name \"Your name\"\` with your own name"
    exit 1
fi 

if [[ -z $GITHUB_USER ]]
then
    echo "GITHUB_USER is not set. Please run \`export GITHUB_USER=<your GithubUsername\`"
    exit 1
fi

if [[ -z $GITHUB_TOKEN ]]
then
    echo "GITHUB_TOKEN is not set. Please run \`export GITHUB_TOKEN=<your token>\`"
    exit 1
fi

if [[ $1 == "delete" ]]
then
  github-release delete \
    --owner $GITHUB_USER \
    --repo collections \
    --tag "0.2.1-custom" 
elif [[ $1 == "upload" ]]
then
  github-release upload \
  --owner $GITHUB_USER \
  --repo collections \
  --tag "0.2.1-custom" \
  --name "0.2.1-custom" \
  --body "Release of custom collection" \
  ci/release/*
else
  echo "Must supply at least one argument. Valid arguments are either 'upload' or 'delete'"
  exit 1
fi