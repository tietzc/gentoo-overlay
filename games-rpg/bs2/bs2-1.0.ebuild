# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils multilib unpacker

DESCRIPTION="Broken Sword 2: Remastered"
HOMEPAGE="https://www.gog.com/game/broken_sword_2__the_smoking_mirror"
SRC_URI="gog_broken_sword_2_remastered_2.0.0.2.sh"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	amd64? (
		dev-libs/json-c[abi_x86_32(-)]
		media-libs/libsdl[abi_x86_32(-),X,opengl,pulseaudio]
		media-libs/openal[abi_x86_32(-)]
	)
	x86? (
		dev-libs/json-c
		media-libs/libsdl[X,opengl,pulseaudio]
		media-libs/openal
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

	dodir "${dir}"
	rm "${S}"/game/libopenal.so.1 \
		"${S}"/game/libSDL-1.2.so.0 || die
	mv "${S}/game" "${D}${dir}/" || die
	dosym /usr/$(get_abi_LIBDIR x86)/libSDL.so "${dir}"/game/libSDL-1.2.so.0

	make_wrapper ${PN} "./BS2Remastered_i386" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Broken Sword 2: Remastered"
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
