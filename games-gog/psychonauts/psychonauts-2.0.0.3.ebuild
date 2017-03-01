# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Psychonauts"
HOMEPAGE="https://www.gog.com/game/psychonauts"
SRC_URI="gog_psychonauts_${PV}.sh"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/json-c[abi_x86_32(-)]
	media-libs/libsdl[abi_x86_32(-),X,opengl,sound,video]
	media-libs/libvorbis[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/psychonauts/game/Psychonauts"

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

	rm "${S}"/game/libopenal.so.1 \
		"${S}"/game/libSDL-1.2.so.0 || die

	dodir "${dir}"
	mv "${S}/game" "${D}${dir}/" || die

	make_wrapper ${PN} "./Psychonauts" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Psychonauts"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog "If you are using opensource drivers you should consider installing:"
	elog "  media-libs/libtxc_dxtn"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
