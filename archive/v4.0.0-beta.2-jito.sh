#!/bin/bash -e

export GIT_COMMITTER_NAME="patch-applier"
export GIT_COMMITTER_EMAIL="patch-applier@localhost"

# Remove previous patch
rm -f patch*.{diff,patch}

# Download patch files into your local repo directory
curl -L -o patch_add_multicast_shred_check_service.patch \
	https://github.com/jito-foundation/jito-solana/commit/9d86237ca60491f6765a277a46ec2e5b56800133.patch

# git fetch
# git checkout $TAG
git rev-parse HEAD
git am patch_add_multicast_shred_check_service.patch

# Build and deploy as you normally would
