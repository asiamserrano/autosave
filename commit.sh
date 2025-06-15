#!/bin/bash

# add all swift files
git add \*.swift

# add specific non-swift files 
git add .gitignore
#git add Assets.xcassets/
git add autosave.xcodeproj/
git add README.md 
git add commit.sh
git add relations.txt


# commit, push, status
git commit -m "${1:-updates}"  
git push
git status