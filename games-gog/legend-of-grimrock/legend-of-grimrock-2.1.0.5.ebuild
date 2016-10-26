# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Legend of Grimrock"
HOMEPAGE="https://www.gog.com/game/legend_of_grimrock"
SRC_URI="gog_legend_of_grimrock_${PV}.sh"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	|| (
		media-libs/libtxc_dxtn
		x11-drivers/ati-drivers
		x11-drivers/nvidia-drivers
	)
	media-libs/freeimage[png]
	media-libs/freetype:2
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libvorbis
	media-libs/openal"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/legend-of-grimrock/game/Grimrock.bin.x86*"

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
	rm -r \
		"${S}"/game/lib{,64} \
		"${S}"/game/xdg-{open,utils} \
		"${S}"/game/Grimrock.bin.$(usex amd64 "x86" "x86_64") || die
	mv "${S}/game" "${D}${dir}/" || die

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Legend Of Grimrock"
	make_wrapper ${PN} "./Grimrock.bin.$(usex amd64 "x86_64" "x86")" "${dir}/game"
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
