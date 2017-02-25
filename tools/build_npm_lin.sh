#!/bin/bash
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

set -e

root=$(cd "$(dirname "$0")/.." && pwd)
build_root=$root/build
nodejs_build_root=$root/build_nodejs
npm_build_root=$build_root/dist_pkgs/npm
npm_source_root=$root/dist_pkgs/npm

# clear the NPM build folder so we have a fresh build
rm -rf $npm_build_root/az-iot-gw-lin
mkdir -p $npm_build_root/az-iot-gw-lin/bin

pushd $npm_build_root


# Copy linux package definition files 
cp -r $npm_source_root/az-iot-gw-lin/. ./az-iot-gw-lin
cp $root/License.txt ./az-iot-gw-lin
mv ./az-iot-gw-lin/License.txt ./az-iot-gw-lin/LICENSE

# copy libnode.so.XX and its symbol link file.
cp $build_root/core/libgateway.so ./az-iot-gw-lin/bin
cp $root/install-deps/lib/libaziotsharedutil.so ./az-iot-gw-lin/bin
cp $root/install-deps/lib/libnanomsg.so ./az-iot-gw-lin/bin
cp $root/install-deps/lib/libnanomsg.so.* ./az-iot-gw-lin/bin
cp $nodejs_build_root/dist/lib/libnode.so.* ./az-iot-gw-lin/bin
cp $nodejs_build_root/dist/lib/libnode.so ./az-iot-gw-lin/bin
cp $build_root/bindings/nodejs/libnodejs_binding.so ./az-iot-gw-lin/bin
cp $build_root/dist_pkgs/gw/gw ./az-iot-gw-lin/bin

npm pack ./az-iot-gw-lin

popd

