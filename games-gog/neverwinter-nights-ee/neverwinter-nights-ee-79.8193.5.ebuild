# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg

DESCRIPTION="Neverwinter Nights: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/neverwinter_nights_enhanced_edition_pack"

BASE_SRC_URI="neverwinter_nights_enhanced_edition_jenkins_neverwinter_nights_gog_build_and_upload_to_nightly_98_34746.sh"
EXP1_SRC_URI="neverwinter_nights_enhanced_edition_darkness_over_daggerford_jenkins_neverwinter_nights_gog_build_and_upload_to_nightly_98_34746.sh"
EXP2_SRC_URI="neverwinter_nights_enhanced_edition_tyrants_of_the_moonsea_jenkins_neverwinter_nights_gog_build_and_upload_to_nightly_98_34746.sh"

SRC_URI="
	${BASE_SRC_URI}
	exp1? ( ${EXP1_SRC_URI} )
	exp2? ( ${EXP2_SRC_URI} )
"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+exp1 +exp2"
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
	use exp1 && einfo "and \"${EXP1_SRC_URI}\""
	use exp2 && einfo "and \"${EXP2_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"
	use exp1 && unpack_zip "${DISTDIR}/${EXP1_SRC_URI}"
	use exp2 && unpack_zip "${DISTDIR}/${EXP2_SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	dodoc game/lang/en/docs/legacy/{NWN_OnlineManual,NWN_SoU_OnlineManual,NWNHordes_Manual}.pdf

	rm -r game/{lang,util} \
		game/bin/{macos,win32} \
		game/goggame-*.{hashdb,info} || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/bin/linux-x86/nwmain-linux

	make_wrapper ${PN} "./nwmain-linux" "${dir}"/bin/linux-x86
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Neverwinter Nights: Enhanced Edition"
}
