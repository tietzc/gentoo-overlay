# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Torchlight II"
HOMEPAGE="https://www.gog.com/game/torchlight_ii"
SRC_URI="gog_torchlight_2_${PV}.sh"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

# use bundled dev-games/{cegui,ogre} and media-libs/fmod for now

RDEPEND="
	dev-libs/expat
	dev-libs/openssl
	media-libs/freeimage[jpeg,png]
	media-libs/freetype:2
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libvorbis"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/torchlight2/game/lib*/*
	opt/torchlight2/game/ModLauncher.bin.x86*
	opt/torchlight2/game/Torchlight2.bin.x86*"

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
		"${S}"/game/lib$(usex amd64 "" "64") \
		"${S}"/game/lib$(usex amd64 "64" "")/{libfreeimage.so.3,libfreetype.so.6,libSDL2-2.0.so.0} \
		"${S}"/game/ModLauncher.bin.$(usex amd64 "x86" "x86_64") \
		"${S}"/game/Torchlight2.bin.$(usex amd64 "x86" "x86_64") || die
	mv "${S}/game" "${D}${dir}/" || die

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Torchlight II"
	make_wrapper ${PN} "./Torchlight2.bin.$(usex amd64 "x86_64" "x86")" "${dir}/game"
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
