# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg

DESCRIPTION="Gone Home"
HOMEPAGE="https://www.gog.com/game/gone_home"
SRC_URI="gone_home_${PV//./_}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
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

	rm -r game/Launch.sh \
		game/GoneHome.$(usex amd64 "x86" "x86_64") \
		game/GoneHome_Data/Mono/$(usex amd64 "x86" "x86_64") \
		game/GoneHome_Data/Plugins/$(usex amd64 "x86" "x86_64") \
		game/goggame-1207665163.{hashdb,info}|| die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/GoneHome.$(usex amd64 "x86_64" "x86")

	make_wrapper ${PN} "./GoneHome.$(usex amd64 "x86_64" "x86")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Gone Home"
}