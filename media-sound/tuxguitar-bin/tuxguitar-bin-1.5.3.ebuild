# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils xdg

MY_P="tuxguitar-${PV}-linux-x86_64"

DESCRIPTION="Multitrack guitar tablature editor and player. Binary package"
HOMEPAGE="http://www.tuxguitar.com.ar"
SRC_URI="https://sourceforge.net/projects/tuxguitar/files/TuxGuitar/TuxGuitar-${PV}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="alsa fluidsynth timidity"
RESTRICT="mirror"

RDEPEND="
	virtual/jre
	alsa? ( media-libs/alsa-lib )
	fluidsynth? ( media-sound/fluidsynth[alsa?] )
	timidity? ( media-sound/timidity++[alsa?] )
"

DOCS=( doc/{AUTHORS,CHANGES,README} )

S="${WORKDIR}/${MY_P}"

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r dist lib share vst-client

	exeinto "${dir}"
	doexe tuxguitar.sh

	einstalldocs

	make_wrapper ${PN} "./tuxguitar.sh" "${dir}"
	newicon -s 96 share/skins/Oxygen/icon.png ${PN}.png
	make_desktop_entry ${PN} "TuxGuitar"
}
