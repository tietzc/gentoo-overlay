# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="To the Moon"
HOMEPAGE="https://www.gog.com/game/to_the_moon"
SRC_URI="gog_to_the_moon_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

# use bundled dev-games/physfs, dev-lang/ruby:2.1, and media-libs/sdl-sound for now

RDEPEND="
	dev-libs/libsigc++:2
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl2-image[jpeg,png]
	media-libs/sdl2-ttf
	sys-libs/zlib"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/${PN}/lib*/*
	opt/${PN}/ToTheMoon.bin.x86*"

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
	local dir="/opt/${PN}"

	rm -r game/legal \
		game/lib$(usex amd64 "" "64") \
		game/COPYING-*.txt \
		game/ToTheMoon.bin.$(usex amd64 "x86" "x86_64") || die

	find game/lib$(usex amd64 "64" "") -type f \
		! -name "libphysfs.so.1" \
		! -name "libruby.so.2.1" \
		! -name "libSDL_sound-1.0.so.1" \
		-delete || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/ToTheMoon.bin.$(usex amd64 "x86_64" "x86")

	make_wrapper ${PN} "./ToTheMoon.bin.$(usex amd64 "x86_64" "x86")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "To The Moon"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
