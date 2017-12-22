# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="Gabriel Knight 2: The Beast Within"
HOMEPAGE="https://www.gog.com/game/gabriel_knight_2_the_beast_within"
SRC_URI="
	setup_gabriel_knight2_${PV}.exe
	setup_gabriel_knight2_${PV}-1.bin
	setup_gabriel_knight2_${PV}-2.bin"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND=">=games-engines/scummvm-2.0.0"

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
	innoextract "${DISTDIR}/setup_gabriel_knight2_${PV}.exe" || die
}

src_install() {
	local dir="/opt/${PN}"

	icotool -x app/GK2.ICO || die

	rm -r app/DOSBOX \
		app/dosboxGK2{,_single}.conf \
		app/GameuxInstallHelper.dll \
		app/goggame.dll || die

	insinto "${dir}"
	doins -r app/.

	make_wrapper ${PN} "scummvm -f -p "${dir}" gk2"
	newicon -s 32 GK2_1_32x32x4.png ${PN}.png
	make_desktop_entry ${PN} "Gabriel Knight 2: The Beast Within"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
