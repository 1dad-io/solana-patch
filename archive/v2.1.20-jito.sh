#!/bin/bash -e

# Remove previous patch. It has not changed, but simplifies the instructions
rm -f patch.diff

# Download patch files into your local jito-solana repo directory
wget https://gist.githubusercontent.com/t-nelson/9c1af95e0edc2eab39012f325e66738a/raw/42fd988678954a0486494bcc0d610eaf1f68b574/patch.diff
wget https://gist.githubusercontent.com/t-nelson/9c1af95e0edc2eab39012f325e66738a/raw/c8ac5c46f7640f8d59be1d4b8d9dd13824ffe2b1/patch-2.diff

# Confirm file integrity with shasum (sha256)
shasum -a256 patch.diff # be4dfdb3354f79fc3b674d9e2b05256f19fa65de2191597c8d4d9550d5b97f60
shasum -a256 patch-2.diff # c59673c1d11a30be836d6e487dc46d3d3b32c7f4c0da884d2b484a59d2dd4736

# git fetch
# git checkout v2.1.20-jito
git rev-parse HEAD # 8738e9f05aed405e5d0da8119ce23efa8b17a96e
git am patch.diff
git am patch-2.diff
export CI_COMMIT="$(git rev-parse --short=8 HEAD)"

# HEAD should now be
#    “hash the scalar proof components into the transcript to derive `c`
#   in range proof”
# The sha will vary depending on your local settings
