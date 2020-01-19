# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg

DESCRIPTION="Doom 3 BFG (data files)"
HOMEPAGE="https://www.gog.com/game/doom_3_bfg_edition"
SRC_URI="
	setup_doom_3_bfg_${PV}_(13452).exe
	setup_doom_3_bfg_${PV}_(13452)-1.bin
"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	games-engines/rbdoom3bfg
"
BDEPEND="
	>=app-arch/innoextract-1.7
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	innoextract "${DISTDIR}/setup_doom_3_bfg_${PV}_(13452).exe" || die
}

src_install() {
	rm app/base/default.cfg || die

	insinto /usr/share/games/doom3bfg/base
	doins -r app/base/.

	newicon -s 128 app/language_setup.png doom3bfg.png
	make_desktop_entry rbdoom3bfg "Doom 3: BFG Edition" doom3bfg
}
