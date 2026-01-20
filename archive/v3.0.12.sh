#!/bin/bash -e

export GIT_COMMITTER_NAME="patch-applier"
export GIT_COMMITTER_EMAIL="patch-applier@localhost"

# Remove previous patch
rm -f patch*.diff

# Download patch files into your local repo directory
wget https://gist.githubusercontent.com/tigarcia/786710511f365c44a6467027d87a8506/raw/527e8558494911d9927d68bd860373145b8b6f22/patch1-updated.diff
wget https://gist.githubusercontent.com/tigarcia/8c465ca5e7d47a514a39efd5354db8f2/raw/2faa8da4aa8171de454d991d7f2a7afc0078002e/patch2.diff

# Confirm files' integrity with shasum (sha256)
# Expected hash for patch1-updated.diff:
# 2709747e9c11cb2b229e2148f6e1fbb5a3a280af02679b2e8e4b17b0b8a246e2
shasum -a 256 patch1-updated.diff

# Expected hash for patch2.diff:
# 15da1a3d73c62f15728fee1f7d1fd2ffba5991a38afa28b73f5aef7ade11bc9a
shasum -a 256 patch2.diff

# git fetch

# select the TAG based on corresponding client
# TAG=v3.0.13      # Agave
# TAG=v3.0.13-jito # Jito Solana
# TAG=v3.0.12-bam  # Jito BAM
# git checkout $TAG

# Expected agave rev-parse: 90098d261e2be2f898769d9ee35141597f1a2234
# Expected jito-solana rev-parse: 49c11e6c08b6e4b0263b77179dfd6134c77c2cbf
# Expected jito-bam rev-parse: 7023419b950edfc63e660d75ed1cf11676d087ba
git rev-parse HEAD

git am patch1-updated.diff
git am patch2.diff

# HEAD should now be
# gossip: fix duplicate shred handler buffer pruning
# commit before head should be
# filter unauthorized votes and check authorized voter
git log -n 2 HEAD

# Build and deploy as you normally would
