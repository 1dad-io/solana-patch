#!/bin/bash -e

export GIT_COMMITTER_NAME="patch-applier"
export GIT_COMMITTER_EMAIL="patch-applier@localhost"

# Remove previous patch
rm -f patch*.{diff,patch}

# Download patch files into your local repo directory
git remote remove juan-malbeclabs 2>/dev/null || true
git remote add juan-malbeclabs https://github.com/juan-malbeclabs/jito-solana_mcast.git
git fetch juan-malbeclabs
git diff v4.0.0-rc.0-jito...juan-malbeclabs/multicast-root-receiver-v4.0 > patch.diff

# Confirm file integrity with shasum (sha256)

# git fetch
# git checkout $TAG
git rev-parse HEAD
git apply patch.diff

# Build and deploy as you normally would
