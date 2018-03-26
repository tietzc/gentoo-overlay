# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="The Curse of Monkey Island"
HOMEPAGE="https://www.gog.com/game/the_curse_of_monkey_island"
SRC_URI="setup_the_curse_of_monkey_island_${PV}_(18253).exe"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="games-engines/scummvm"

DEPEND="
	app-arch/innoextract
	media-gfx/icoutils"

S="${WORKDIR}"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	innoextract "${DISTDIR}/${SRC_URI}" || die
}

src_install() {
	local dir="/opt/gog/${PN}"

	icotool -x app/goggame-1528148981.ico || die

	insinto "${dir}"
	doins -r app/{RESOURCE,COMI.LA0,COMI.LA1,COMI.LA2}

	make_wrapper ${PN} "scummvm -f -p "${dir}" comi"
	newicon -s 128 goggame-1528148981_7_128x128x32.png ${PN}.png
	make_desktop_entry ${PN} "The Curse Of Monkey Island"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
