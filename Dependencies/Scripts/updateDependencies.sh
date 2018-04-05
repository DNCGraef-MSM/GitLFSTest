#!/bin/bash

# Update & fetch & build dependencies as dynamic libraries according to Cartfile spec

# Constants
FRAMEWORKS_DIR="./Dependencies/Frameworks"
CARTHAGE_BUILD_DIR="./Carthage/Build/iOS"

# Navigate to root dir
cd ../../

# Update dependencies
# carthage update

# Move required frameworks into target directory
cp -r "$CARTHAGE_BUILD_DIR"/*.framework "$FRAMEWORKS_DIR"

# Clean up any existing libs
find "$FRAMEWORKS_DIR" -name '*.zip' -delete

# Zip each framework for sync with source control (as binary)
for framework in "$FRAMEWORKS_DIR"/*
do
	# Name is last path segment, minus .framework extension
	frameworkName=`echo "$framework" | rev | cut -d "/" -f1 | rev | cut -d "." -f1`
	
	# Zip up new libs
	zip "$FRAMEWORKS_DIR"/"$frameworkName".zip "$framework"
done

# Remove non-zipped libs
rm -rf "$FRAMEWORKS_DIR"/*.framework