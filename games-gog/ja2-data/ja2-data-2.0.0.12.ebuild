# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Jagged Alliance 2 (data files)"
HOMEPAGE="https://www.gog.com/game/jagged_alliance_2"
SRC_URI="setup_jagged_alliance2_${PV}.exe"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="games-engines/ja2-stracciatella"

DEPEND="app-arch/innoextract"

S="${WORKDIR}"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	innoextract --lowercase "${DISTDIR}/${SRC_URI}" || die
}

src_install() {
	insinto /usr/share/ja2/data
	doins -r app/data/.
}
