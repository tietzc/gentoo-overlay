# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs desktop unpacker wrapper xdg

DESCRIPTION="Pillars of Eternity"
HOMEPAGE="https://www.gog.com/game/pillars_of_eternity_hero_edition"

BASE_SRC_URI="pillars_of_eternity_${PV//./_}.sh"
DE_SRC_URI="PoE_v3.07.1318_PX1_PX2_German_Fix.7z"
DLC1_SRC_URI="pillars_of_eternity_deadfire_pack_${PV//./_}.sh"
DLC2_SRC_URI="pillars_of_eternity_preorder_item_and_pet_${PV//./_}.sh"
EXP1_SRC_URI="pillars_of_eternity_the_white_march_part_1_${PV//./_}.sh"
EXP2_SRC_URI="pillars_of_eternity_the_white_march_part_2_${PV//./_}.sh"

SRC_URI="
	${BASE_SRC_URI}
	dlc1? ( ${DLC1_SRC_URI} )
	dlc2? ( ${DLC2_SRC_URI} )
	exp1? ( ${EXP1_SRC_URI} )
	exp2? ( ${EXP2_SRC_URI} )
	l10n_de? ( ${DE_SRC_URI} )
"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+dlc1 +dlc2 +exp1 +exp2 l10n_de"
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/atk
	media-libs/fontconfig
	media-libs/freetype:2
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango
"
BDEPEND="
	app-arch/unzip
	l10n_de? ( app-arch/7zip )
"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use dlc1 && einfo "and \"${DLC1_SRC_URI}\""
	use dlc2 && einfo "and \"${DLC2_SRC_URI}\""
	use exp1 && einfo "and \"${EXP1_SRC_URI}\""
	use exp2 && einfo "and \"${EXP2_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."

	if use l10n_de; then
		einfo "Please also download \"${DE_SRC_URI}\" from:"
		einfo "  https://github.com/Xaratas/pillarsofeternity-german-patch-with-expansions/releases"
		einfo "and place it in your DISTDIR directory."
	fi
}

pkg_pretend() {
	local build_size=19
	use exp1 && build_size=25

	if use exp2; then
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
	use exp1 && unpack_zip "${DISTDIR}/${EXP1_SRC_URI}"
	use exp2 && unpack_zip "${DISTDIR}/${EXP2_SRC_URI}"
	use l10n_de && 7zz x -bd -o"${S}/game" "${DISTDIR}/${DE_SRC_URI}" || die
}

src_install() {
	local dir="/opt/gog/${PN}"

	rm game/libsteam_api.so \
		game/PillarsOfEternity_Data/Plugins/libCSteamworks.so \
		game/PillarsOfEternity_Data/Plugins/libsteam_api.so || die

	dodir "${dir}"
	mv game/* "${D}/${dir}" || die

	# ensure sane permissions
	find "${D}/${dir}" -type f -exec chmod 0644 '{}' + || die
	find "${D}/${dir}" -type d -exec chmod 0755 '{}' + || die
	fperms +x "${dir}"/PillarsOfEternity

	make_wrapper ${PN} "./PillarsOfEternity" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Pillars Of Eternity"
}
