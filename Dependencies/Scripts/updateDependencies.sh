#!/bin/bash

# Helper script for resolving dependencies using Carthage, then pulling those dependencies
# as zip files into "Dependencies" directory for commit to source control via Git LFS

# How to update dependencies:
# 	1. Update project dependencies in Cartfile in root directory as required
# 	2. Run this script from the [root]/Dependencies/Scripts directory
# 	3. Review and commit the zip files in [root]/Dependencies/Frameworks directory to source control

# Constants
FRAMEWORKS_DIR="./Dependencies/Frameworks"
CARTHAGE_BUILD_DIR="./Carthage/Build/iOS"

# Navigate to root dir
cd ../../

# Update dependencies
# carthage update --platform ios

# Move required frameworks into target directory
cp -r "$CARTHAGE_BUILD_DIR"/*.framework "$FRAMEWORKS_DIR"

# Clean up any existing libs
find "$FRAMEWORKS_DIR" -name '*.zip' -delete

cd "$FRAMEWORKS_DIR"

# Zip each framework for sync with source control (as binary)
for framework in ./*
do
# 	Name is last path segment, minus .framework extension
	frameworkName=`echo "$framework" | rev | cut -d "/" -f1 | rev | cut -d "." -f1`
	
# 	Zip up new libs
	zip -r ./"$frameworkName".zip "$framework"
done

# Remove non-zipped libs
rm -rf ./*.framework