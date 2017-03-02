#!/bin/bash
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.


root=$(cd "$(dirname "$0")/.." && pwd)
build_root=$root/build
nodejs_build_root=$root/build_nodejs

# -----------------------------------------------------------------------------
# -- Build the NODE runtime.
# -----------------------------------------------------------------------------
$root/tools/build_nodejs.sh "$@"
[ $? -eq 0 ] || exit $?

# -----------------------------------------------------------------------------
# -- Set the NODE variables.
# -----------------------------------------------------------------------------
export NODE_INCLUDE="$nodejs_build_root/dist/inc"
export NODE_LIB="$nodejs_build_root/dist/lib"

# -----------------------------------------------------------------------------
# -- Build the GW core runtime with all valid bindings.
# -----------------------------------------------------------------------------
$root/tools/build.sh --enable-nodejs-binding --enable-java-binding --enable-dotnet-core-binding "$@"
[ $? -eq 0 ] || exit $?

# -----------------------------------------------------------------------------
# -- Build the NPM packages for Linux.
# -----------------------------------------------------------------------------
$root/tools/build_npm_lin.sh "$@"
[ $? -eq 0 ] || exit $?

# -----------------------------------------------------------------------------
# -- Upload the *.tgz to Azure File Share Service.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# -- Publish the NPM package to Myget as preview.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# -- Publish the NPM package to NPMJS.
# -----------------------------------------------------------------------------

