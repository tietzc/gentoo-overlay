# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg

DESCRIPTION="Baldur's Gate 2: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/baldurs_gate_2_enhanced_edition"
SRC_URI="baldur_s_gate_2_enhanced_edition_en_${PV//./_}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/expat
	dev-libs/openssl-compat:1.0.0
	media-libs/openal
	virtual/opengl
	x11-libs/libX11"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/gog/${PN}/BaldursGateII*"

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

	dodoc -r game/Manuals/.

	rm -r game/BaldursGateII$(usex amd64 "" "64") \
		game/Manuals || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/BaldursGateII$(usex amd64 "64" "")

	make_wrapper ${PN} "./BaldursGateII$(usex amd64 "64" "")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Baldurs Gate 2: Enhanced Edition"
}
