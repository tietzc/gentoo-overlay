# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Aragami"
HOMEPAGE="https://www.gog.com/game/aragami"
SRC_URI="gog_aragami_${PV}.sh"

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
	x11-libs/pango"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/gog/${PN}/Aragami.x86*
	opt/gog/${PN}/Aragami_Data/Mono/x86*/*.so"

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

	rm -r game/Aragami.$(usex amd64 "x86" "x86_64") \
		game/Aragami_Data/Mono/$(usex amd64 "x86" "x86_64") \
		game/Aragami_Data/Plugins/$(usex amd64 "x86" "x86_64") || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/Aragami.$(usex amd64 "x86_64" "x86")

	make_wrapper ${PN} "./Aragami.$(usex amd64 "x86_64" "x86")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Aragami"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
