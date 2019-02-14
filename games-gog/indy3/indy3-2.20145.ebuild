# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg

DESCRIPTION="Indiana Jones and the Last Crusade"
HOMEPAGE="https://www.gog.com/game/indiana_jones_and_the_last_crusade"
SRC_URI="indiana_jones_and_the_last_crusade_en_gog_${PV//./_}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="games-engines/scummvm"

BDEPEND="app-arch/unzip"

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

	insinto "${dir}"
	doins -r data/.

	make_wrapper ${PN} "scummvm -f -p "${dir}" indy3"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Indiana Jones And The Last Crusade"
}
