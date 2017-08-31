# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs eutils gnome2-utils unpacker

DESCRIPTION="Tyranny"
HOMEPAGE="https://www.gog.com/game/tyranny_commander_edition"

BASE_SRC_URI="gog_tyranny_${PV}.sh"
DLC1_SRC_URI="gog_tyranny_tales_from_the_tiers_dlc_2.1.0.2.sh"
DLC2_SRC_URI="gog_tyranny_pre_order_dlc_2.0.0.1.sh"
SRC_URI="${BASE_SRC_URI}
	dlc1? ( ${DLC1_SRC_URI} )
	dlc2? ( ${DLC2_SRC_URI} )"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+dlc1 +dlc2"
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
	opt/${PN}/Tyranny
	opt/${PN}/Tyranny.x86
	opt/${PN}/Tyranny_Data/Mono/x86*/libmono.so"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use dlc1 && einfo "and \"${DLC1_SRC_URI}\""
	use dlc2 && einfo "and \"${DLC2_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"

	if use dlc1 ; then
		unpack_zip "${DISTDIR}/${DLC1_SRC_URI}"
	fi

	if use dlc2 ; then
		unpack_zip "${DISTDIR}/${DLC2_SRC_URI}"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	rm -r game/Tyranny$(usex amd64 ".x86" "") \
		game/Tyranny_Data/Mono/$(usex amd64 "x86" "x86_64") \
		game/Tyranny_Data/Plugins/$(usex amd64 "x86" "x86_64") \
		game/Tyranny_Data/Plugins/$(usex amd64 "x86_64" "x86")/libCSteamworks.so \
		game/Tyranny_Data/Plugins/$(usex amd64 "x86_64" "x86")/libpops_api.so \
		game/Tyranny_Data/Plugins/$(usex amd64 "x86_64" "x86")/libsteam_api.so || die

	dodir "${dir}"
	mv game/* "${D%/}${dir}" || die

	# ensure sane permissions
	find "${D%/}/${dir}" -type f -exec chmod 0644 '{}' + || die
	find "${D%/}/${dir}" -type d -exec chmod 0755 '{}' + || die
	fperms +x "${dir}"/Tyranny$(usex amd64 "" ".x86")

	make_wrapper ${PN} "./Tyranny$(usex amd64 "" ".x86")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Tyranny"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
