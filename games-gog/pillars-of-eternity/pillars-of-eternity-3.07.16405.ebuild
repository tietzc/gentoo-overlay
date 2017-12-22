# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs eutils gnome2-utils unpacker versionator

DESCRIPTION="Pillars of Eternity"
HOMEPAGE="https://www.gog.com/game/pillars_of_eternity_hero_edition"

BASE_SRC_URI="pillars_of_eternity_en_$(replace_all_version_separators '_').sh"
DLC1_SRC_URI="pillars_of_eternity_white_march_part_1_dlc_en_3_07_16598.sh"
DLC2_SRC_URI="pillars_of_eternity_white_march_part_2_dlc_en_3_07_16598.sh"
DLC3_SRC_URI="pillars_of_eternity_deadfire_pack_dlc_en_3_07_16380.sh"
DLC4_SRC_URI="gog_pillars_of_eternity_preorder_item_and_pet_dlc_2.0.0.2.sh"
DE_SRC_URI="PoE_v3.07.1280_PX1_PX2_German_Fix.7z"
SRC_URI="${BASE_SRC_URI}
	dlc1? ( ${DLC1_SRC_URI} )
	dlc2? ( ${DLC2_SRC_URI} )
	dlc3? ( ${DLC3_SRC_URI} )
	dlc4? ( ${DLC4_SRC_URI} )
	l10n_de? ( ${DE_SRC_URI} )"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+dlc1 +dlc2 +dlc3 +dlc4 l10n_de"
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

DEPEND="
	app-arch/unzip
	l10n_de? ( app-arch/p7zip )"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/gog/${PN}/PillarsOfEternity
	opt/gog/${PN}/PillarsOfEternity_Data/Mono/x86_64/libmono.so"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use dlc1 && einfo "and \"${DLC1_SRC_URI}\""
	use dlc2 && einfo "and \"${DLC2_SRC_URI}\""
	use dlc3 && einfo "and \"${DLC3_SRC_URI}\""
	use dlc4 && einfo "and \"${DLC4_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo

	if use l10n_de ; then
		einfo "Please also download \"${DE_SRC_URI}\" from:"
		einfo "  https://github.com/Xaratas/pillarsofeternity-german-patch-with-expansions/releases"
		einfo "and move/link it to \"${DISTDIR}\""
		einfo
	fi
}

pkg_pretend() {
	local build_size=15
	use dlc1 && build_size=21

	if use dlc2 ; then
		(( build_size += 5 ))
	fi

	local CHECKREQS_DISK_BUILD=${build_size}G
	check-reqs_pkg_pretend
}

pkg_setup() {
	pkg_pretend
}

src_unpack() {
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"
	use dlc1 && unpack_zip "${DISTDIR}/${DLC1_SRC_URI}"
	use dlc2 && unpack_zip "${DISTDIR}/${DLC2_SRC_URI}"
	use dlc3 && unpack_zip "${DISTDIR}/${DLC3_SRC_URI}"
	use dlc4 && unpack_zip "${DISTDIR}/${DLC4_SRC_URI}"
	use l10n_de && 7za x -bd -o"${S}/game" "${DISTDIR}/${DE_SRC_URI}" || die
}

src_install() {
	local dir="/opt/gog/${PN}"

	rm game/PillarsOfEternity_Data/Plugins/x86_64/libCSteamworks.so \
		game/PillarsOfEternity_Data/Plugins/x86_64/libsteam_api.so || die

	dodir "${dir}"
	mv game/* "${D%/}/${dir}" || die

	# ensure sane permissions
	find "${D%/}/${dir}" -type f -exec chmod 0644 '{}' + || die
	find "${D%/}/${dir}" -type d -exec chmod 0755 '{}' + || die
	fperms +x "${dir}"/PillarsOfEternity

	make_wrapper ${PN} "./PillarsOfEternity" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Pillars Of Eternity"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
