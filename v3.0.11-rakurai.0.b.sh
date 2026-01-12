#!/bin/bash -e

# config
rakurai_api=https://api.rakurai.io/api/v1
rakurai_os=ubuntu_24.04
rakurai_ver="v${version}"

version_exists_for_os() {
	local os="$1"
	local ver="$2"
	curl -sS "$rakurai_api/scheduler/versions" \
		| jq -e --arg os "$os" --arg ver "$ver" '.[] | select(.os == $os) | (.mainnet_and_testnet + .testnet_only) | index($ver)' >/dev/null
}

rakurai(){
	[ -n "$RAA" ] || error "RAA must be configured"
	
	# sign the Rakurai Activation Account
	info "Signing the RAA"
	sig=$(${solana} sign-offchain-message $RAA --keypair ${staked}) || error "Error signing the RAA"
	
	# get available versions
	info "Fetching available versions"
	version_exists_for_os "${rakurai_os}" "${rakurai_ver}" || error ${err_pkg_unsupported//PKG/${rakurai_ver}}
	
	# download the scheduler binary
	info "Downloading the scheduler binary"
	curl -o rakurai-scheduler.tar.gz "${rakurai_api}/downloads/scheduler" \
		-H "Content-Type: application/json" \
		-d "{
			\"activation_account\": \"$RAA\",
			\"signature\": \"${sig}\",
			\"version\": \"${rakurai_ver}\",
			\"os\": \"${rakurai_os}\"
		}" \
		--fail-with-body || error "$(cat rakurai-scheduler.tar.gz)"
		
	# extract the scheduler binary
	info "Extracting the scheduler binary"
	mkdir -p $REPO/target/release/
	tar -zxvf ./rakurai-scheduler.tar.gz
	cp librakurai_scheduler_1_0.so $REPO/target/release/librakurai_scheduler_1_0.so
	
	# build
	info "Building the client"
	PATCH_BUILD=1 # building here
	cargo build --release --features build_validator
	
	# export the scheduler binary path
	# export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$REPO/target/release"
	
	# make install
	if [ -n "$TARGET" ]; then
		mkdir -p $TARGET/bin
		find "$REPO/target/release" -maxdepth 1 -type f -executable -exec cp -au '{}' "$TARGET/bin/" \;
	fi
}

# run the patch
rakurai
