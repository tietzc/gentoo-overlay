# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper xdg

DESCRIPTION="Planescape Torment: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/planescape_torment_enhanced_edition"
SRC_URI="planescape_torment_enhanced_edition_${PV//./_}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
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
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	rm game/Torment || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/Torment64

	make_wrapper ${PN} "./Torment64" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Planescape Torment: Enhanced Edition"
}
