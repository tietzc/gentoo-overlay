# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Layers of Fear"
HOMEPAGE="https://www.gog.com/game/layers_of_fear"
SRC_URI="gog_layers_of_fear_${PV}.sh"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/atk
	media-libs/fontconfig
	media-libs/freetype:2
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango"

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
	rm \
		"${S}"/game/Launcher.exe \
		"${S}"/game/LOF_Data/Plugins/x86_64/libCSteamworks.so \
		"${S}"/game/LOF_Data/Plugins/x86_64/libsteam_api.so || die
	mv "${S}/game" "${D}${dir}/" || die

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Layers Of Fear"
	make_wrapper ${PN} "./LOF" "${dir}/game"
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
