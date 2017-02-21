#!/bin/bash
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

set -e

build_root=$(cd "$(dirname "$0")/.." && pwd)
build_root=$build_root/build/npm

# clear the Node.js build folder so we have a fresh build
rm -rf $build_root
mkdir -p $build_root
