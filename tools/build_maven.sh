#!/bin/bash
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

set -e

root=$(cd "$(dirname "$0")/.." && pwd)
build_root=$root/build/dist_pkgs/maven/iot-gateway-linux

# Clear the build folder so we have a fresh build
rm -rf $build_root
mkdir -p $build_root

pushd $build_root

# Copy maven package source files
mkdir ./src
cp -r $root/dist_pkgs/maven/iot-gateway-linux/src/. ./src
cp $root/dist_pkgs/maven/iot-gateway-linux/pom.xml ./pom.xml
mkdir ./src/main/resources
cp $root/License.txt ./src/main/resources/LICENSE

# Copy binary files for azure iot gateway to resources
cp $root/build/core/libgateway.so                   ./src/main/resources
cp $root/install-deps/lib/libaziotsharedutil.so     ./src/main/resources
cp $root/install-deps/lib/libnanomsg.so             ./src/main/resources
cp $root/install-deps/lib/libnanomsg.so.*           ./src/main/resources
cp $root/build/bindings/java/libjava_module_host.so ./src/main/resources
cp $root/build/dist_pkgs/gw/gw                      ./src/main/resources

# Publish to maven local repository
mvn clean install
[ $? -eq 0 ] || exit $?

popd
