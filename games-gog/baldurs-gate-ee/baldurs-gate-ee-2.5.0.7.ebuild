# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils multilib unpacker

DESCRIPTION="Baldur's Gate: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/baldurs_gate_enhanced_edition"

BASE_SRC_URI="gog_baldur_s_gate_enhanced_edition_${PV}.sh"
SOD_SRC_URI="gog_baldur_s_gate_siege_of_dragonspear_2.3.0.4.sh"
SRC_URI="${BASE_SRC_URI}
	sod? ( ${SOD_SRC_URI} )"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sod"
RESTRICT="bindist fetch"

RDEPEND="
	amd64? (
		dev-libs/expat[abi_x86_32(-)]
		dev-libs/json-c[abi_x86_32(-)]
		dev-libs/openssl[abi_x86_32(-)]
		media-libs/openal[abi_x86_32(-)]
		virtual/opengl[abi_x86_32(-)]
		x11-libs/libX11[abi_x86_32(-)]
	)
	x86? (
		dev-libs/expat
		dev-libs/json-c
		dev-libs/openssl
		media-libs/openal
		virtual/opengl
		x11-libs/libX11
	)"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/baldurs-gate-ee/game/BaldursGate"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use sod && einfo "and \"${SOD_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	einfo "unpacking base data..."
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"

	if use sod ; then
		einfo "unpacking sod data..."
		unpack_zip "${DISTDIR}/${SOD_SRC_URI}"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r game
	fperms +x "${dir}"/game/BaldursGate

	dodir "${dir}"/lib
	dosym /usr/$(get_abi_LIBDIR x86)/libjson-c.so "${dir}"/lib/libjson.so.0

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Baldurs Gate: Enhanced Edition"
	make_wrapper ${PN} "./BaldursGate" "${dir}/game" "${dir}/lib"
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
