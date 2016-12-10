# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit check-reqs eutils gnome2-utils multilib unpacker

DESCRIPTION="Tyranny"
HOMEPAGE="https://www.gog.com/game/tyranny_commander_edition"

BASE_SRC_URI="gog_tyranny_${PV}.sh"
DLC_SRC_URI="gog_tyranny_pre_order_dlc_2.0.0.1.sh"
SRC_URI="${BASE_SRC_URI}
	dlc? ( ${DLC_SRC_URI} )"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+dlc"
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/atk[abi_x86_32(-)]
	media-libs/fontconfig[abi_x86_32(-)]
	media-libs/freetype:2[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/cairo[abi_x86_32(-)]
	x11-libs/gdk-pixbuf:2[abi_x86_32(-)]
	x11-libs/gtk+:2[abi_x86_32(-)]
	x11-libs/pango[abi_x86_32(-)]"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

CHECKREQS_DISK_BUILD="14G"

QA_PREBUILT="
	opt/tyranny/game/Tyranny
	opt/tyranny/game/Tyranny_Data/Mono/x86/libmono.so
	opt/tyranny/game/Tyranny_Data/Plugins/x86/libpops_api.so"

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
	einfo "unpacking base data..."
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"

	if use dlc ; then
		einfo "unpacking dlc data..."
		unpack_zip "${DISTDIR}/${DLC_SRC_URI}"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	dodir "${dir}"
	rm "${S}"/game/Tyranny_Data/Plugins/x86/libCSteamworks.so \
		"${S}"/game/Tyranny_Data/Plugins/x86/libsteam_api.so || die
	mv "${S}/game" "${D}${dir}/" || die

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Tyranny"
	make_wrapper ${PN} "./Tyranny" "${dir}/game"
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
