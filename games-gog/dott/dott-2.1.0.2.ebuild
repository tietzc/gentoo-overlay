# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils multilib unpacker

DESCRIPTION="Day of the Tentacle: Remastered"
HOMEPAGE="https://www.gog.com/game/day_of_the_tentacle_remastered"
SRC_URI="gog_day_of_the_tentacle_remastered_${PV}.sh"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

# use bundled media-libs/fmod for now

RDEPEND="
	amd64? (
		dev-libs/expat[abi_x86_32(-)]
		media-libs/alsa-lib[abi_x86_32(-)]
		virtual/opengl[abi_x86_32(-)]
		x11-libs/libX11[abi_x86_32(-)]
	)
	x86? (
		dev-libs/expat
		media-libs/alsa-lib
		virtual/opengl
		x11-libs/libX11
	)"

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

	make_wrapper ${PN} "./Dott" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Day Of The Tentacle: Remastered"

	dodir "${dir}"
	rm "${S}"/game/lib/libsteam_api.so || die
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