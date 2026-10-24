#!/bin/bash -e

export GIT_COMMITTER_NAME="patch-applier"
export GIT_COMMITTER_EMAIL="patch-applier@localhost"

PATCH_COMMIT="ded3f0d7d0932bd09bd2d0038e46afbcfef4ba81"

# Run from your local jito-solana repository checked out at v4.3.2-jito
# Fetch only the specific commit to apply
git fetch --no-tags https://github.com/jito-foundation/jito-solana.git "$PATCH_COMMIT"

git rev-parse HEAD
git cherry-pick "$PATCH_COMMIT"

# Build and deploy as you normally would
