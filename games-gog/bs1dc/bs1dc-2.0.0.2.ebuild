# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper xdg

DESCRIPTION="Broken Sword: Director's Cut"
HOMEPAGE="https://www.gog.com/game/broken_sword_directors_cut"
SRC_URI="gog_broken_sword_director_s_cut_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch"

RDEPEND="
	media-libs/libsdl[X,opengl,sound,video]
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

	mv game/x86_64/bs1dc_x86_64 game/ || die

	rm -r game/{BS1DC,i386,x86_64} || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/bs1dc_x86_64

	make_wrapper ${PN} "./bs1dc_x86_64" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Broken Sword: Director's Cut"
}
