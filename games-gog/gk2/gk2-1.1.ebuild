# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="Gabriel Knight 2: The Beast Within"
HOMEPAGE="https://www.gog.com/game/gabriel_knight_2_the_beast_within"
SRC_URI="
	setup_gabriel_knight_2_-_the_beast_within_${PV}_(20239).exe
	setup_gabriel_knight_2_-_the_beast_within_${PV}_(20239)-1.bin"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND=">=games-engines/scummvm-2.0.0"

DEPEND="
	>=app-arch/innoextract-1.7
	media-gfx/icoutils"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	innoextract "${DISTDIR}/setup_gabriel_knight_2_-_the_beast_within_${PV}_(20239).exe" || die
}

src_install() {
	local dir="/opt/gog/${PN}"

	icotool -x GK2.ICO || die

	rm -r __{redist,support} \
		app \
		commonappdata \
		scummvm \
		tmp \
		goggame-1207658837.{hashdb,info,script} || die

	insinto "${dir}"
	doins -r .

	make_wrapper ${PN} "scummvm -f -p "${dir}" gk2"
	newicon -s 32 GK2_1_32x32x4.png ${PN}.png
	make_desktop_entry ${PN} "Gabriel Knight 2: The Beast Within"

	# delete temporary icon
	rm "${D%/}/${dir}"/GK2_1_32x32x4.png || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
