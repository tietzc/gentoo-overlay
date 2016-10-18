# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Broken Sword 5: The Serpent's Curse"
HOMEPAGE="https://www.gog.com/game/broken_sword_5_the_serpents_curse"
SRC_URI="gog_broken_sword_5_the_serpent_s_curse_2.0.0.2.sh"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	media-libs/openal
	virtual/opengl"

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
	mv "${S}/game/x86_64/BS5_$(usex amd64 "x86_64" "i386")" "${S}/game/" || die
	rm -r \
		"${S}"/game/x86_64 \
		"${S}"/game/i386 \
		"${S}"/game/BS5 || die
	mv "${S}/game" "${D}${dir}/" || die

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Broken Sword 5: The Serpent's Curse"
	make_wrapper ${PN} "./BS5_$(usex amd64 "x86_64" "i386")" "${dir}/game"
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
