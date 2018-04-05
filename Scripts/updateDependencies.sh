#!/bin/bash

# Helper script for resolving dependencies using Carthage, and updating Git LFS to track
# those large binaries separately from the source code repo

# How to update dependencies:
# 	1. Update project dependencies in Cartfile in root directory as required
# 	2. Run this script from the [root]/Dependencies/Scripts directory
# 	3. Review and commit updated .gitattributes file + frameworks to source control

# Navigate to project root
cd ..

# Update dependencies
carthage update --platform ios

# Clear existing LFS tracked files
rm .gitattributes

# Track all binary dependencies in Git LFS
for framework in ./Carthage/Build/iOS/*.framework
do
	# Binary name is last path segment, minus .framework extension
	binaryName=`echo "$framework" | rev | cut -d "/" -f1 | rev | cut -d "." -f1`
	
	# Track binary under Git LFS	
	git lfs track "$framework"/"$binaryName"
done
