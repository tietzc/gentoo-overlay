# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Layers of Fear"
HOMEPAGE="https://www.gog.com/game/layers_of_fear"

BASE_SRC_URI="gog_layers_of_fear_${PV}.sh"
DLC_SRC_URI="gog_layers_of_fear_inheritance_dlc_2.0.0.1.sh"
SRC_URI="${BASE_SRC_URI}
	dlc? ( ${DLC_SRC_URI} )"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+dlc"
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

QA_PREBUILT="
	opt/layers-of-fear/game/LOF
	opt/layers-of-fear/game/LOF_Data/Mono/x86_64/libmono.so"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use dlc && einfo "and \"${DLC_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	einfo "unpacking data..."
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"

	if use dlc ; then
		einfo "unpacking dlc data..."
		unpack_zip "${DISTDIR}/${DLC_SRC_URI}"
	fi
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
