# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs desktop eutils unpacker xdg

DESCRIPTION="Shadow Tactics: Blades of the Shogun"
HOMEPAGE="https://www.gog.com/game/shadow_tactics_blades_of_the_shogun"
SRC_URI="shadow_tactics_blades_of_the_shogun_en_2_2_10_f_21297.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/atk[abi_x86_32(-)]
	media-libs/fontconfig[abi_x86_32(-)]
	media-libs/freetype:2[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/cairo[abi_x86_32(-)]
	x11-libs/gdk-pixbuf:2[abi_x86_32(-)]
	x11-libs/gtk+:2[abi_x86_32(-)]
	x11-libs/pango[abi_x86_32(-)]
"
BDEPEND="
	app-arch/unzip
"

S="${WORKDIR}/data/noarch"

CHECKREQS_DISK_BUILD="10G"

pkg_nofetch() {
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	rm game/Shadow\ Tactics_Data/Plugins/x86/libCSteamworks.so \
		game/Shadow\ Tactics_Data/Plugins/x86/libsteam_api.so || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/Shadow\ Tactics

	make_wrapper ${PN} "./Shadow\ Tactics" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Shadow Tactics: Blades Of The Shogun"
}
