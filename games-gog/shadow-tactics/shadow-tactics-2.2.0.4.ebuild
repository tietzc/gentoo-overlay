# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs eutils gnome2-utils unpacker

DESCRIPTION="Shadow Tactics: Blades of the Shogun"
HOMEPAGE="https://www.gog.com/game/shadow_tactics_blades_of_the_shogun"
SRC_URI="gog_shadow_tactics_blades_of_the_shogun_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/atk[abi_x86_32(-)]
	media-libs/fontconfig[abi_x86_32(-)]
	media-libs/freetype:2[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/cairo[abi_x86_32(-)]
	x11-libs/gdk-pixbuf:2[abi_x86_32(-)]
	x11-libs/gtk+:2[abi_x86_32(-)]
	x11-libs/pango[abi_x86_32(-)]"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

CHECKREQS_DISK_BUILD="10G"

QA_PREBUILT="
	opt/${PN}/*
	opt/${PN}/*/Mono/x86/libmono.so
	opt/${PN}/*/Plugins/x86/libRenderingPlugin.so"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/${PN}"

	rm game/Shadow\ Tactics_Data/Plugins/x86/libCSteamworks.so \
		game/Shadow\ Tactics_Data/Plugins/x86/libsteam_api.so || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/Shadow\ Tactics

	make_wrapper ${PN} "./Shadow\ Tactics" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Shadow Tactics: Blades Of The Shogun"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
