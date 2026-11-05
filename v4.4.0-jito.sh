#!/bin/bash -e

export GIT_COMMITTER_NAME="patch-applier"
export GIT_COMMITTER_EMAIL="patch-applier@localhost"

# Download the following patch files into your local Agave repo directory
wget https://gist.githubusercontent.com/esemeniuc/67d2deb185340b58c6cbf3af07b36175/raw/2594378e47c81842d873643dd05d9a411eb02b46/loaderv3-programdata-size-floor-v4.4.patch

# Confirm integrity for each file with shasum (sha256)

# Expected hash for patch.diff:
# 3c68e7c38386021fd44f8575818d44136c360db2381b772707b9ebac8326328e
shasum -a 256 loaderv3-programdata-size-floor-v4.4.patch

# Confirm the correct base is being worked off

# select the TAG based on corresponding client
# TAG=v4.4.0-jito      # Jito Solana & BAM
git fetch
git checkout $TAG
git submodule update --init --recursive

# Expected jito-solana rev-parse: 9a9756848e20745ab5e720741fef6c81dacbf455
git rev-parse HEAD

# Apply the patches
git am loaderv3-programdata-size-floor-v4.4.patch

# HEAD should now be:
# Applying: fix: add loader-v3 ProgramData size floor and implicit read locks
git log -n 1 HEAD

# Build and deploy as you normally would
