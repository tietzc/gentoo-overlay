# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="Amnesia: The Dark Descent"
HOMEPAGE="https://www.gog.com/game/amnesia_the_dark_descent"
SRC_URI="gog_amnesia_the_dark_descent_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	media-libs/devil[jpeg,png]
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="opt/${PN}/Amnesia.bin.x86*"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	unzip -qo "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/${PN}"

	rm -r game/lib{,64} \
		game/Amnesia.bin.$(usex amd64 "x86" "x86_64") \
		game/Launcher.bin.x86{,_64} || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/Amnesia.bin.$(usex amd64 "x86_64" "x86")

	make_wrapper ${PN} "./Amnesia.bin.$(usex amd64 "x86_64" "x86")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Amnesia: The Dark Descent"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
