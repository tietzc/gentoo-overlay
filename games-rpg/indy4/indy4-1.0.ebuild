# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Indiana Jones and the Fate of Atlantis"
HOMEPAGE="https://www.gog.com/game/indiana_jones_and_the_fate_of_atlantis"
SRC_URI="gog_indiana_jones_and_the_fate_of_atlantis_2.2.0.27.sh"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="games-engines/scummvm"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	einfo "unpacking data..."
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins data/{ATLANTIS.*,MONSTER.SOU}

	newicon -s 256 support/icon.png ${PN}.png
	make_wrapper "${PN}" "scummvm -f -p "${dir}" atlantis"
	make_desktop_entry "${PN}" "Indiana Jones And The Fate Of Atlantis"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
