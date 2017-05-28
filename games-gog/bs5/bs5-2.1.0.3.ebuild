# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Broken Sword 5: The Serpent's Curse"
HOMEPAGE="https://www.gog.com/game/broken_sword_5_the_serpents_curse"
SRC_URI="gog_broken_sword_5_the_serpent_s_curse_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/expat
	media-libs/openal
	virtual/opengl
	x11-libs/libX11"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/${PN}/game/BS5_i386
	opt/${PN}/game/BS5_x86_64"

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

	mv "${S}/game/$(usex amd64 "x86_64" "i386")/BS5_$(usex amd64 "x86_64" "i386")" "${S}/game/" || die

	rm -r \
		"${S}"/game/BS5 \
		"${S}"/game/i386 \
		"${S}"/game/x86_64 || die

	dodir "${dir}"
	mv "${S}/game" "${D}${dir}/" || die

	make_wrapper ${PN} "./BS5_$(usex amd64 "x86_64" "i386")" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Broken Sword 5: The Serpent's Curse"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
