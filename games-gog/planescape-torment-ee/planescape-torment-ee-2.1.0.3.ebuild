# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Planescape Torment: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/planescape_torment_enhanced_edition"
SRC_URI="gog_planescape_torment_enhanced_edition_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/expat
	dev-libs/openssl
	media-libs/openal
	virtual/opengl
	x11-libs/libX11"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/${PN}/game/Torment*"

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

	rm "${S}"/game/Torment$(usex amd64 "" "64") || die

	dodir "${dir}"
	mv "${S}/game" "${D}${dir}/" || die

	make_wrapper ${PN} "./Torment$(usex amd64 "64" "")" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Planescape Torment: Enhanced Edition"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
