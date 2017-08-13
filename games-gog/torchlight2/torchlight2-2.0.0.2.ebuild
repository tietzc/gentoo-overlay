# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

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

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/${PN}/lib*/*
	opt/${PN}/ModLauncher.bin.x86*
	opt/${PN}/Torchlight2.bin.x86*"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	unzip -qo "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/${PN}"

	rm -r game/lib$(usex amd64 "" "64") \
		game/lib$(usex amd64 "64" "")/{libfreeimage.so.3,libfreetype.so.6,libSDL2-2.0.so.0} \
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
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
