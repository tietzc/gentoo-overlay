# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper xdg

DESCRIPTION="Psychonauts"
HOMEPAGE="https://www.gog.com/game/psychonauts"
SRC_URI="gog_psychonauts_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch"

RDEPEND="
	media-libs/libsdl[abi_x86_32(-),X,opengl,sound,video]
	media-libs/libvorbis[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
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

	rm game/{libopenal.so.1,libSDL-1.2.so.0} || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/Psychonauts

	make_wrapper ${PN} "./Psychonauts" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Psychonauts"
}
