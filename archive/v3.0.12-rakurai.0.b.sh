#!/bin/bash -e

# apply security patch
source $PATCH/v3.0.12.sh

# apply original patch
source $PATCH/v3.0.11-rakurai.0.b.sh
