# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs eutils gnome2-utils

DESCRIPTION="Tyranny"
HOMEPAGE="https://www.gog.com/game/tyranny_commander_edition"

BASE_SRC_URI="gog_tyranny_${PV}.sh"
DLC_SRC_URI="gog_tyranny_pre_order_dlc_2.0.0.1.sh"
SRC_URI="${BASE_SRC_URI}
	dlc? ( ${DLC_SRC_URI} )"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
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

CHECKREQS_DISK_BUILD="14G"

QA_PREBUILT="
	opt/${PN}/game/Tyranny
	opt/${PN}/game/Tyranny.x86
	opt/${PN}/game/Tyranny_Data/Mono/x86*/libmono.so"

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
	unzip -qo "${DISTDIR}/${BASE_SRC_URI}"

	if use dlc ; then
		einfo "unpacking dlc data..."
		unzip -qo "${DISTDIR}/${DLC_SRC_URI}"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	rm -r "${S}"/game/Tyranny$(usex amd64 ".x86" "") \
		"${S}"/game/Tyranny_Data/Mono/$(usex amd64 "x86" "x86_64") \
		"${S}"/game/Tyranny_Data/Plugins/$(usex amd64 "x86" "x86_64") \
		"${S}"/game/Tyranny_Data/Plugins/$(usex amd64 "x86_64" "x86")/libCSteamworks.so \
		"${S}"/game/Tyranny_Data/Plugins/$(usex amd64 "x86_64" "x86")/libpops_api.so \
		"${S}"/game/Tyranny_Data/Plugins/$(usex amd64 "x86_64" "x86")/libsteam_api.so || die

	dodir "${dir}"
	mv "${S}/game" "${D}${dir}/" || die

	make_wrapper ${PN} "./Tyranny$(usex amd64 "" ".x86")" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Tyranny"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
