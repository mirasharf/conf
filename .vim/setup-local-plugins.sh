#!/bin/bash
#
# setup-local-plugins.sh: TODO: Add description here.
#
# Author: Marco Elver <me AT marcoelver.com>
# Date: Thu Apr 12 00:17:42 BST 2012

cd `dirname $0`
BUNDLE_DIR="$(pwd)/bundle"
INIT_BUNDLES_VIM="$(pwd)/plugin/init_bundles.vim"

setup_pathogen() {
	echo "===== Fetching Pathogen ====="
	mkdir -p "autoload" "$BUNDLE_DIR" "plugin"
	wget "https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim" \
		 -O "autoload/pathogen.vim"
}

fetch_plugins() {
	echo "===== Fetching Plugins ====="
	cd "$BUNDLE_DIR"

	# Clang complete
	git clone "https://github.com/Rip-Rip/clang_complete.git" "clang_complete"
	echo "let g:clang_complete_copen = 1" >> "$INIT_BUNDLES_VIM"

	#
}

update_plugins() {
	echo "===== Updating Plugins ====="
	cd "$BUNDLE_DIR"

	for bundle in "clang_complete"; do
		if [[ -d "$bundle" ]]; then
			pushd "$bundle"
			 git pull
			popd
		fi
	done
}

if [[ ! -f "autoload/pathogen.vim" ]]; then
	setup_pathogen
	fetch_plugins
else
	update_plugins
fi

echo "===== Done ====="
