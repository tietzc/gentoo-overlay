# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils xdg

DESCRIPTION="Multitrack guitar tablature editor and player. Binary package"
HOMEPAGE="http://www.tuxguitar.com.ar"
SRC_URI="
	amd64? ( https://sourceforge.net/projects/tuxguitar/files/TuxGuitar/TuxGuitar-${PV}/tuxguitar-${PV}-linux-x86_64.tar.gz )
	x86? ( https://sourceforge.net/projects/tuxguitar/files/TuxGuitar/TuxGuitar-${PV}/tuxguitar-${PV}-linux-x86.tar.gz )
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="alsa fluidsynth timidity"
RESTRICT="mirror"

RDEPEND="
	virtual/jre
	alsa? ( media-libs/alsa-lib )
	fluidsynth? ( media-sound/fluidsynth[alsa?] )
	timidity? ( media-sound/timidity++[alsa?] )
"

DOCS=( doc/{AUTHORS,CHANGES,README} )

src_unpack() {
	unpack ${A}
	mkdir -p "${S}" || die
	mv "${WORKDIR}"/tuxguitar-${PV}-linux-*/* "${S}" || die
	rmdir tuxguitar-${PV}-linux-* || die
}

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