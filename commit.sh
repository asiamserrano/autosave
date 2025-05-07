#!/bin/bash
git add .gitignore
git add commit.sh
git add \*.swift
git add Assets.xcassets/
git add autosave.xcodeproj/
git commit -m "${1:-updates}"  
git push
git status