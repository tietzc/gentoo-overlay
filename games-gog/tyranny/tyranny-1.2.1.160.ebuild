# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs eutils gnome2-utils unpacker

DESCRIPTION="Tyranny"
HOMEPAGE="https://www.gog.com/game/tyranny_commander_edition"

BASE_SRC_URI="tyranny_v${PV//./_}_v2_25169.sh"
DLC1_SRC_URI="tyranny_bastard_s_wound_dlc_en_1_2_1_0158_15398.sh"
DLC2_SRC_URI="tyranny_tales_from_the_tiers_dlc_en_1_2_1_0158_15398.sh"
DLC3_SRC_URI="tyranny_pre_order_dlc_en_1_0_14773.sh"
SRC_URI="${BASE_SRC_URI}
	dlc1? ( ${DLC1_SRC_URI} )
	dlc2? ( ${DLC2_SRC_URI} )
	dlc3? ( ${DLC3_SRC_URI} )"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+dlc1 +dlc2 +dlc3"
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

CHECKREQS_DISK_BUILD="15G"

QA_PREBUILT="
	opt/gog/${PN}/Tyranny.x86*
	opt/gog/${PN}/Tyranny_Data/Mono/x86*/libmono.so
	opt/gog/${PN}/Tyranny_Data/Plugins/x86*/libpops_api.so"

pkg_nofetch() {
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use dlc1 && einfo "and \"${DLC1_SRC_URI}\""
	use dlc2 && einfo "and \"${DLC2_SRC_URI}\""
	use dlc3 && einfo "and \"${DLC3_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"
	use dlc1 && unpack_zip "${DISTDIR}/${DLC1_SRC_URI}"
	use dlc2 && unpack_zip "${DISTDIR}/${DLC2_SRC_URI}"
	use dlc3 && unpack_zip "${DISTDIR}/${DLC3_SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	rm -r game/Tyranny.x86$(usex amd64 "" "_64") \
		game/Tyranny_Data/Mono/$(usex amd64 "x86" "x86_64") \
		game/Tyranny_Data/Plugins/$(usex amd64 "x86" "x86_64") \
		game/Tyranny_Data/Plugins/$(usex amd64 "x86_64" "x86")/libCSteamworks.so \
		game/Tyranny_Data/Plugins/$(usex amd64 "x86_64" "x86")/libsteam_api.so || die

	dodir "${dir}"
	mv game/* "${D%/}/${dir}" || die

	# ensure sane permissions
	find "${D%/}/${dir}" -type f -exec chmod 0644 '{}' + || die
	find "${D%/}/${dir}" -type d -exec chmod 0755 '{}' + || die
	fperms +x "${dir}"/Tyranny.x86$(usex amd64 "_64" "")

	make_wrapper ${PN} "./Tyranny.x86$(usex amd64 "_64" "")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Tyranny"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
