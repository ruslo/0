#!/bin/bash -e

set -x

rm -rf _builds _static

mkdir _static

sphinx-build -W . _build
