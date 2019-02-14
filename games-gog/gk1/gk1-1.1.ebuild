# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils xdg

DESCRIPTION="Gabriel Knight: Sins of the Fathers"
HOMEPAGE="https://www.gog.com/game/gabriel_knight_sins_of_the_fathers"
SRC_URI="setup_gabriel_knight_-_sins_of_the_fathers_${PV}_(20239).exe"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND=">=games-engines/scummvm-2.0.0"

BDEPEND="
	>=app-arch/innoextract-1.7
	media-gfx/icoutils"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	innoextract "${DISTDIR}/setup_gabriel_knight_-_sins_of_the_fathers_${PV}_(20239).exe" || die
}

src_install() {
	local dir="/opt/gog/${PN}"

	icotool -x GK1.ICO || die

	rm -r __{redist,support} \
		app \
		commonappdata \
		scummvm \
		tmp \
		goggame-1207658828.{hashdb,info,script} || die

	insinto "${dir}"
	doins -r .

	make_wrapper ${PN} "scummvm -f -p "${dir}" gk1"
	newicon -s 32 GK1_1_32x32x4.png ${PN}.png
	make_desktop_entry ${PN} "Gabriel Knight: Sins Of The Fathers"

	# delete temporary icon
	rm "${D}/${dir}"/GK1_1_32x32x4.png || die
}
