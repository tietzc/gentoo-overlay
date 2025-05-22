# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper xdg

MY_P="tuxguitar-${PV}-linux-swt-amd64"

DESCRIPTION="Multitrack guitar tablature editor and player. Binary package"
HOMEPAGE="https://www.tuxguitar.app"
SRC_URI="https://github.com/helge17/tuxguitar/releases/download/${PV}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	media-sound/fluidsynth
	>=virtual/jre-11:*
"

DOCS=( doc/{AUTHORS,CHANGES,README.md} )

S="${WORKDIR}/${MY_P}"

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r dist lib lv2-client share

	exeinto "${dir}"
	doexe tuxguitar.sh

	einstalldocs

	make_wrapper ${PN} "./tuxguitar.sh" "${dir}"
	newicon -s 96 share/pixmaps/tuxguitar.png ${PN}.png
	make_desktop_entry ${PN} "TuxGuitar"
}
