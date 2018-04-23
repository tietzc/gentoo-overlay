# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Legend of Grimrock"
HOMEPAGE="https://www.gog.com/game/legend_of_grimrock"
SRC_URI="gog_legend_of_grimrock_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/expat
	media-libs/freeimage[jpeg,png,tiff]
	media-libs/freetype:2
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib[minizip]"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/gog/${PN}/Grimrock.bin.x86*"

pkg_nofetch() {
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	rm -r game/lib{,64} \
		game/xdg-{open,utils} \
		game/Grimrock.bin.$(usex amd64 "x86" "x86_64") || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/Grimrock.bin.$(usex amd64 "x86_64" "x86")

	make_wrapper ${PN} "./Grimrock.bin.$(usex amd64 "x86_64" "x86")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Legend Of Grimrock"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
