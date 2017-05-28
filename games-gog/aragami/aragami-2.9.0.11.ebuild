# Copyright 1999-2017 Gentoo Foundation
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
	opt/${PN}/game/Aragami.x86*
	opt/${PN}/game/Aragami_Data/Mono/x86*/*.so"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	einfo "unpacking data..."
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/${PN}"

	rm -r \
		"${S}"/game/Aragami.$(usex amd64 "x86" "x86_64") \
		"${S}"/game/Aragami_Data/Mono/$(usex amd64 "x86" "x86_64") \
		"${S}"/game/Aragami_Data/Plugins/$(usex amd64 "x86" "x86_64") || die

	dodir "${dir}"
	mv "${S}/game" "${D}${dir}/" || die

	fperms -R 0755 "${dir}"/game/Aragami_Data

	make_wrapper ${PN} "./Aragami.$(usex amd64 "x86_64" "x86")" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Aragami"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
