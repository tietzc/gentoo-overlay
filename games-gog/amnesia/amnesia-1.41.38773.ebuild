# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper xdg

DESCRIPTION="Amnesia: The Dark Descent"
HOMEPAGE="https://www.gog.com/game/amnesia_the_dark_descent"
SRC_URI="amnesia_the_dark_descent_${PV//./_}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch"

RDEPEND="
	media-libs/devil[jpeg,png]
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
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

	dodoc game/{Manual_en,Remember\ -\ Short\ Story\ Collection}.pdf

	rm -r game/lib{,64} \
		game/Amnesia.bin.x86 \
		game/Launcher.bin.x86{,_64} \
		game/{Manual_en,Remember\ -\ Short\ Story\ Collection}.pdf || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/Amnesia.bin.x86_64

	make_wrapper ${PN} "./Amnesia.bin.x86_64" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Amnesia: The Dark Descent"
}
