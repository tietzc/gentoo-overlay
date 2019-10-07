# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg

DESCRIPTION="Icewind Dale: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/icewind_dale_enhanced_edition"
SRC_URI="icewind_dale_enhanced_edition_en_${PV//./_}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/expat
	dev-libs/openssl-compat
	media-libs/openal
	virtual/opengl
	x11-libs/libX11"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/gog/${PN}/IcewindDale*"

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

	rm game/IcewindDale$(usex amd64 "" "64") || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/IcewindDale$(usex amd64 "64" "")

	make_wrapper ${PN} "./IcewindDale$(usex amd64 "64" "")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Icewind Dale: Enhanced Edition"
}
