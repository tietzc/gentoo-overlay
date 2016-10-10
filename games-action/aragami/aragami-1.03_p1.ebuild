# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Aragami"
HOMEPAGE="https://www.gog.com/game/aragami"
SRC_URI="gog_aragami_2.3.0.5.sh"

LICENSE="all-rights-reserved"
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

	case ${ARCH} in
		amd64)
			rm -r \
				"${S}"/game/Aragami.x86 \
				"${S}"/game/Aragami_Data/Mono/x86 \
				"${S}"/game/Aragami_Data/Plugins/x86 || die
			make_wrapper ${PN} "./Aragami.x86_64" "${dir}/game"
			;;
		x86)
			rm -r \
				"${S}"/game/Aragami.x86_64 \
				"${S}"/game/Aragami_Data/Mono/x86_64 \
				"${S}"/game/Aragami_Data/Plugins/x86_64 || die
			make_wrapper ${PN} "./Aragami.x86" "${dir}/game"
			;;
	esac

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Aragami"

	dodir "${dir}"
	mv "${S}/game" "${D}${dir}/" || die
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
