# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="Doom 3 BFG (data files)"
HOMEPAGE="https://www.gog.com/game/doom_3_bfg_edition"
SRC_URI="
	setup_doom_3_bfg_${PV}_(13452)_(g).exe
	setup_doom_3_bfg_${PV}_(13452)_(g)-1.bin
	setup_doom_3_bfg_${PV}_(13452)_(g)-2.bin"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="games-engines/rbdoom3bfg"

DEPEND=">=app-arch/innoextract-1.6"

S="${WORKDIR}"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	innoextract --gog "${DISTDIR}/setup_doom_3_bfg_${PV}_(13452)_(g).exe" || die
}

src_install() {
	rm app/base/default.cfg || die

	insinto /usr/share/doom3bfg/base
	doins -r app/base/.

	newicon -s 128 app/language_setup.png doom3bfg.png
	make_desktop_entry RBDoom3BFG "Doom 3: BFG Edition" doom3bfg.png
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
