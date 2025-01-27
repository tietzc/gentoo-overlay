# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper xdg

DESCRIPTION="Baldur's Gate: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/baldurs_gate_enhanced_edition"

BASE_SRC_URI="baldur_s_gate_enhanced_edition_${PV//./_}.sh"
SOD_SRC_URI="baldur_s_gate_siege_of_dragonspear_${PV//./_}.sh"
SRC_URI="${BASE_SRC_URI}
	sod? ( ${SOD_SRC_URI} )"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+sod"
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/expat
	dev-libs/openssl-compat:1.0.0
	media-libs/openal
	virtual/opengl
	x11-libs/libX11
"
BDEPEND="
	app-arch/unzip
"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use sod && einfo "and \"${SOD_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"

	if use sod; then
		unpack_zip "${DISTDIR}/${SOD_SRC_URI}"
	fi
}

src_install() {
	local dir="/opt/gog/${PN}"

	dodoc -r game/Manuals/.

	rm -r game/Manuals || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/BaldursGate

	make_wrapper ${PN} "./BaldursGate" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Baldurs Gate: Enhanced Edition"
}
