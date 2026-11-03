# solana-patch

Rust source overlays and patch scripts for specific releases of [jito-solana](https://github.com/jito-foundation/jito-solana).

The project began with adaptations of the voting mod developed by Zantetsu of Shinobi Systems and published for [Agave v1.18.23](https://github.com/anza-xyz/agave/releases/tag/v1.18.23). The original work is available in the [voting mod branch](https://github.com/bji/solana/tree/v1.18.23_vote_optimized) and its [implementation commit](https://github.com/bji/solana/commit/915909fc8539d4df7cc11ba14226ad6247c53cdb).

The original mod applies configurable voting criteria after the upstream code identifies a votable slot. It also backfills eligible votes and retains votes whose expiration is no longer required under `VoteStateUpdate`. These changes aim to earn more vote credits while limiting fork lockouts. An escape mechanism allows voting to resume if the configured thresholds prevent progress.

Source overlays contain selected modified Rust files arranged to match their paths in the upstream repository. Where included, `.orig` files preserve the original sources and `.patch` files record the differences. Older versions are kept under `archive/`.

Each versioned shell script (`v<version>.sh`) supplies an independent, additional patch. It can run on its own or alongside the source overlay for the same release.

## How patches are applied

[solana-tools](https://github.com/1dad-io/solana-tools) applies these changes when building the validator from source. Its update workflow:

1. Checks out the requested upstream release tag (`TAG`) and initializes its submodules.
2. Uses the `solana-patch` checkout inside the solana-tools directory as the patch root (`PATCH`). When `git_solana_patch` is configured, it clones or refreshes this checkout from the configured repository.
3. Looks for `$PATCH/$TAG/` and recursively copies any `*.rs` files into the upstream checkout, preserving relative paths and creating directories as needed. Each file replaces its upstream counterpart in full. For example, `$PATCH/$TAG/core/src/consensus.rs` replaces `core/src/consensus.rs` in the validator checkout. This step does not copy or apply `.orig` or `.patch` files.
4. Separately looks for `$PATCH/$TAG.sh` and sources it from the upstream repository root after copying any overlay files. The script runs whether or not an overlay directory exists. When both are present, both apply.
5. Builds and installs the resulting validator. A script that completes its own build and installation can set `PATCH_BUILD=1` to skip this step.

Directory and script names must match the full upstream tag, including any release suffix. The updater selects matching entries at the patch repository root; it does not search `archive/`.

Licensed under [Apache License 2.0](LICENSE).
