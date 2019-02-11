# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg-utils

DESCRIPTION="Torchlight II"
HOMEPAGE="https://www.gog.com/game/torchlight_ii"
SRC_URI="gog_torchlight_2_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

# use bundled dev-games/{cegui,ogre} and media-libs/fmod for now

RDEPEND="
	dev-libs/expat
	media-libs/freeimage[jpeg,png,tiff]
	media-libs/freetype:2
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libvorbis
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/gog/${PN}/lib*/*
	opt/gog/${PN}/ModLauncher.bin.x86*
	opt/gog/${PN}/Torchlight2.bin.x86*"

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

	rm -r game/lib$(usex amd64 "" "64") \
		game/lib$(usex amd64 "64" "")/{libfreeimage.so.3,libfreetype.so.6,libSDL2-2.0.so.0} \
		game/licenses \
		game/ModLauncher.bin.$(usex amd64 "x86" "x86_64") \
		game/Torchlight2.bin.$(usex amd64 "x86" "x86_64") || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/Torchlight2.bin.$(usex amd64 "x86_64" "x86")

	make_wrapper ${PN} "./Torchlight2.bin.$(usex amd64 "x86_64" "x86")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Torchlight II"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
