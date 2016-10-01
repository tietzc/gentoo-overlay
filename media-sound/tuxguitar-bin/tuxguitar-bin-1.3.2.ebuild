# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="TuxGuitar is a multitrack guitar tablature editor and player written in Java-SWT"
HOMEPAGE="http://tuxguitar.herac.com.ar"
SRC_URI="
	x86? ( mirror://sourceforge/project/tuxguitar/TuxGuitar/TuxGuitar-${PV}/tuxguitar-${PV}-linux-x86.tar.gz )
	amd64? ( mirror://sourceforge/project/tuxguitar/TuxGuitar/TuxGuitar-${PV}/tuxguitar-${PV}-linux-x86_64.tar.gz )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa fluidsynth oss timidity"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	fluidsynth? ( media-sound/fluidsynth )
	timidity? ( media-sound/timidity++[alsa?,oss?] )
	virtual/jre"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}" || die
	mv "${WORKDIR}"/tuxguitar-${PV}-linux-*/* "${S}" || die
	rmdir tuxguitar-${PV}-linux-* || die
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r *
	fperms +x "${dir}"/tuxguitar.sh

	newicon -s 96 share/skins/Oxygen/icon.png ${PN}.png
	make_wrapper "${PN}" "${dir}/tuxguitar.sh"
	make_desktop_entry "${PN}" "TuxGuitar"
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
