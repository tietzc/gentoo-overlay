# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit check-reqs eutils gnome2-utils unpacker

DESCRIPTION="Pillars Of Eternity"
HOMEPAGE="https://www.gog.com/game/pillars_of_eternity_hero_edition"

BASE_SRC_URI="gog_pillars_of_eternity_${PV}.sh"
DLC1_SRC_URI="gog_pillars_of_eternity_white_march_part_1_dlc_2.7.0.9.sh"
DLC2_SRC_URI="gog_pillars_of_eternity_white_march_part_2_dlc_2.3.0.4.sh"
DLC3_SRC_URI="gog_pillars_of_eternity_preorder_item_and_pet_dlc_2.0.0.2.sh"
SRC_URI="${BASE_SRC_URI}
	dlc1? ( ${DLC1_SRC_URI} )
	dlc2? ( ${DLC2_SRC_URI} )
	dlc3? ( ${DLC3_SRC_URI} )"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
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

QA_PREBUILT="
	opt/pillars-of-eternity/game/PillarsOfEternity
	opt/pillars-of-eternity/game/PillarsOfEternity_Data/Mono/x86_64/libmono.so"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use dlc1 && einfo "and \"${DLC1_SRC_URI}\""
	use dlc2 && einfo "and \"${DLC2_SRC_URI}\""
	use dlc3 && einfo "and \"${DLC3_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

pkg_pretend() {
	local build_size=15000
	use dlc1 && build_size=21000

	if use dlc2 ; then
		(( build_size += 5000 ))
	fi

	local CHECKREQS_DISK_BUILD=${build_size}M
	check-reqs_pkg_pretend
}

pkg_setup() {
	pkg_pretend
}

src_unpack() {
	einfo "unpacking base data..."
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"

	if use dlc1 ; then
		einfo "unpacking dlc1 data..."
		unpack_zip "${DISTDIR}/${DLC1_SRC_URI}"
	fi

	if use dlc2 ; then
		einfo "unpacking dlc2 data..."
		unpack_zip "${DISTDIR}/${DLC2_SRC_URI}"
	fi

	if use dlc3 ; then
		einfo "unpacking dlc3 data..."
		unpack_zip "${DISTDIR}/${DLC3_SRC_URI}"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	dodir "${dir}"
	rm "${S}"/game/PillarsOfEternity_Data/Plugins/x86_64/libCSteamworks.so \
		"${S}"/game/PillarsOfEternity_Data/Plugins/x86_64/libsteam_api.so || die
	mv "${S}/game" "${D}${dir}/" || die

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Pillars Of Eternity"
	make_wrapper ${PN} "./PillarsOfEternity" "${dir}/game"
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
