# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg

DESCRIPTION="Broken Sword 2: Remastered"
HOMEPAGE="https://www.gog.com/game/broken_sword_2__the_smoking_mirror"
SRC_URI="gog_broken_sword_2_remastered_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	media-libs/libsdl[abi_x86_32(-),X,opengl,sound,video]
	media-libs/libvorbis[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/gog/${PN}/BS2Remastered_i386"

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

	fperms +x "${dir}"/BS2Remastered_i386

	make_wrapper ${PN} "./BS2Remastered_i386" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Broken Sword 2: Remastered"
}
