# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper xdg

DESCRIPTION="Broken Sword 2: Remastered"
HOMEPAGE="https://www.gog.com/game/broken_sword_2__the_smoking_mirror"
SRC_URI="broken_sword_2_remastered_${PV//./_}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch"

RDEPEND="
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libvorbis
	media-libs/openal
	x11-libs/libX11
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

	rm game/{BrokenSword2_i386,BS2} || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/BrokenSword2_x86_64

	make_wrapper ${PN} "./BrokenSword2_x86_64" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Broken Sword 2: Remastered"
}
