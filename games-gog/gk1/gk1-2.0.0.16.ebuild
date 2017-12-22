# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="Gabriel Knight: Sins of the Fathers"
HOMEPAGE="https://www.gog.com/game/gabriel_knight_sins_of_the_fathers"
SRC_URI="setup_gabriel_knight_${PV}.exe"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND=">=games-engines/scummvm-2.0.0"

DEPEND="
	app-arch/innoextract
	app-arch/p7zip
	media-gfx/icoutils"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	innoextract --include app/GK1.GOG "${DISTDIR}/setup_gabriel_knight_${PV}.exe" || die
	7z x -bd -o"${S}" "${WORKDIR}"/app/GK1.GOG || die
}

src_install() {
	local dir="/opt/gog/${PN}"

	icotool -x GK1.ICO || die

	insinto "${dir}"
	doins -r .

	make_wrapper ${PN} "scummvm -f -p "${dir}" gk1"
	newicon -s 32 GK1_1_32x32x4.png ${PN}.png
	make_desktop_entry ${PN} "Gabriel Knight: Sins Of The Fathers"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
