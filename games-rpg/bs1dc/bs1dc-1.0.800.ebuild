# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Broken Sword: Director's Cut"
HOMEPAGE="https://www.gog.com/game/broken_sword_directors_cut"
SRC_URI="gog_broken_sword_director_s_cut_2.0.0.2.sh"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/json-c
	media-libs/libsdl[opengl,pulseaudio]
	media-libs/openal
	x11-libs/libX11"

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

	if use amd64 ; then
		make_wrapper ${PN} "./bs1dc_x86_64" "${dir}/game"
		mv "${S}/game/x86_64/bs1dc_x86_64" "${S}/game/"
	else
		make_wrapper ${PN} "./bs1dc_i386" "${dir}/game"
		mv "${S}/game/i386/bs1dc_i386" "${S}/game/"
	fi

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Broken Sword: Director's Cut"

	dodir "${dir}"
	rm -r \
		"${S}"/game/x86_64 \
		"${S}"/game/i386 \
		"${S}"/game/BS1DC || die
	mv "${S}/game" "${D}${dir}/" || die
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
