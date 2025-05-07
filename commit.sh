#!/bin/bash
git add .gitignore
git add commit.sh
#git add autosave_ios/autosave_ios.xcodeproj/project.pbxproj 
git add \*.swift
git commit -m "${1:-updates}"  
git push
git status