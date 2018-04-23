# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Baldur's Gate 2: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/baldurs_gate_2_enhanced_edition"
SRC_URI="gog_baldur_s_gate_2_enhanced_edition_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/expat[abi_x86_32(-)]
	dev-libs/json-c[abi_x86_32(-)]
	dev-libs/openssl[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/gog/${PN}/BaldursGateII"

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
	local ABI="x86"

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/BaldursGateII

	dodir "${dir}"/lib
	dosym ../../../../usr/$(get_libdir)/libjson-c.so "${dir}"/lib/libjson.so.0

	make_wrapper ${PN} "./BaldursGateII" "${dir}" "${dir}/lib"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Baldurs Gate 2: Enhanced Edition"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
