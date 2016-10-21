# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Gone Home"
HOMEPAGE="https://www.gog.com/game/gone_home"
SRC_URI="gog_gone_home_2.0.0.2.sh"

LICENSE="all-rights-reserved GOG-EULA"
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

	dodir "${dir}"
	rm -r \
		"${S}"/game/GoneHome.$(usex amd64 "x86" "x86_64") \
		"${S}"/game/GoneHome_Data/Mono/$(usex amd64 "x86" "x86_64") \
		"${S}"/game/GoneHome_Data/Plugins/x86/libsteam_api.so || die
	mv "${S}/game" "${D}${dir}/" || die
	fperms -R 0755 "${dir}"/game/GoneHome_Data

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Gone Home"
	make_wrapper ${PN} "./GoneHome.$(usex amd64 "x86_64" "x86")" "${dir}/game"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	# work around localization issue
	sed -i '2i\export LC_ALL=C\' /usr/bin/gone-home || die

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
