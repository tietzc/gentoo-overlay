# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Psychonauts"
HOMEPAGE="https://www.gog.com/game/psychonauts"
SRC_URI="gog_psychonauts_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	media-libs/flac[abi_x86_32(-)]
	media-libs/libsdl[abi_x86_32(-),X,opengl,sound,video]
	media-libs/libvorbis[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/gog/${PN}/Psychonauts"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	rm game/{libopenal.so.1,libSDL-1.2.so.0} || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/Psychonauts

	make_wrapper ${PN} "./Psychonauts" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Psychonauts"
}

pkg_postinst() {
	gnome2_icon_cache_update

	if ! has_version media-libs/libtxc_dxtn ; then
		elog "If you are using opensource drivers you should consider installing:"
		elog "  media-libs/libtxc_dxtn"
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
