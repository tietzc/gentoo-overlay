# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg

DESCRIPTION="Neverwinter Nights: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/neverwinter_nights_enhanced_edition_pack"
SRC_URI="neverwinter_nights_enhanced_edition_jenkins_neverwinter_nights_gog_build_and_upload_to_nightly_98_34746.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""
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
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	dodoc game/lang/en/docs/legacy/{NWN_OnlineManual,NWN_SoU_OnlineManual,NWNHordes_Manual}.pdf

	rm -r game/{lang,util} \
		game/goggame-1097893768.{hashdb,info} || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/bin/linux-x86/nwmain-linux

	make_wrapper ${PN} "./nwmain-linux" "${dir}"/bin/linux-x86
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Neverwinter Nights: Enhanced Edition"
}
