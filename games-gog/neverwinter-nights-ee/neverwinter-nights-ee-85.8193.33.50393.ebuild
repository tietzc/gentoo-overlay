# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper xdg

DESCRIPTION="Neverwinter Nights: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/neverwinter_nights_enhanced_edition_pack"

BASE_SRC_URI="neverwinter_nights_enhanced_edition_${PV//./_}.sh"
DLC1_SRC_URI="neverwinter_nights_pirates_of_the_sword_coast_${PV//./_}.sh"
DLC2_SRC_URI="neverwinter_nights_wyvern_crown_of_cormyr_${PV//./_}.sh"
DLC3_SRC_URI="neverwinter_nights_infinite_dungeons_${PV//./_}.sh"
DLC4_SRC_URI="neverwinter_nights_enhanced_edition_dark_dreams_of_furiae_${PV//./_}.sh"
EXP1_SRC_URI="neverwinter_nights_enhanced_edition_darkness_over_daggerford_${PV//./_}.sh"
EXP2_SRC_URI="neverwinter_nights_tyrants_of_the_moonsea_${PV//./_}.sh"

SRC_URI="
	${BASE_SRC_URI}
	dlc1? ( ${DLC1_SRC_URI} )
	dlc2? ( ${DLC2_SRC_URI} )
	dlc3? ( ${DLC3_SRC_URI} )
	dlc4? ( ${DLC4_SRC_URI} )
	exp1? ( ${EXP1_SRC_URI} )
	exp2? ( ${EXP2_SRC_URI} )
"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+dlc1 +dlc2 +dlc3 +dlc4 +exp1 +exp2"
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/expat
	media-libs/openal
	virtual/opengl
	x11-libs/libX11
"
BDEPEND="
	app-arch/unzip
"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use dlc1 && einfo "and \"${DLC1_SRC_URI}\""
	use dlc2 && einfo "and \"${DLC2_SRC_URI}\""
	use dlc3 && einfo "and \"${DLC3_SRC_URI}\""
	use dlc4 && einfo "and \"${DLC4_SRC_URI}\""
	use exp1 && einfo "and \"${EXP1_SRC_URI}\""
	use exp2 && einfo "and \"${EXP2_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"
	use dlc1 && unpack_zip "${DISTDIR}/${DLC1_SRC_URI}"
	use dlc2 && unpack_zip "${DISTDIR}/${DLC2_SRC_URI}"
	use dlc3 && unpack_zip "${DISTDIR}/${DLC3_SRC_URI}"
	use dlc4 && unpack_zip "${DISTDIR}/${DLC4_SRC_URI}"
	use exp1 && unpack_zip "${DISTDIR}/${EXP1_SRC_URI}"
	use exp2 && unpack_zip "${DISTDIR}/${EXP2_SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	dodoc game/lang/en/docs/legacy/{NWN_OnlineManual,NWN_SoU_OnlineManual,NWNHordes_Manual}.pdf

	rm -r game/util \
		game/bin/{macos,win32} \
		game/lang/{de,en,es,fr,it,pl}/docs || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/bin/linux-x86/{nwmain-linux,nwserver-linux}

	make_wrapper ${PN} "./nwmain-linux" "${dir}"/bin/linux-x86
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Neverwinter Nights: Enhanced Edition"
}
