# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils multilib unpacker

DESCRIPTION="Baldur's Gate 2: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/baldurs_gate_2_enhanced_edition"
SRC_URI="gog_baldur_s_gate_2_enhanced_edition_2.6.0.10.sh"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	amd64? (
		dev-libs/json-c[abi_x86_32(-)]
		dev-libs/openssl[abi_x86_32(-)]
		media-libs/openal[abi_x86_32(-)]
		virtual/opengl[abi_x86_32(-)]
	)
	x86? (
		dev-libs/json-c
		dev-libs/openssl
		media-libs/openal
		virtual/opengl
	)"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	einfo "unpacking data..."
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r game
	fperms +x "${dir}"/game/BaldursGateII

	dodir "${dir}"/lib
	dosym /usr/$(get_abi_LIBDIR x86)/libjson-c.so "${dir}"/lib/libjson.so.0

	newicon -s 256 support/icon.png ${PN}.png
	make_wrapper ${PN} "./BaldursGateII" "${dir}/game" "${dir}/lib"
	make_desktop_entry ${PN} "Baldurs Gate 2: Enhanced Edition"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
