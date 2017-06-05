# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="A Bird Story"
HOMEPAGE="https://www.gog.com/game/a_bird_story"
SRC_URI="gog_a_bird_story_${PV}.sh"

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
	media-libs/sdl2-ttf"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/${PN}/game/lib*/*
	opt/${PN}/game/ABirdStory.amd64
	opt/${PN}/game/ABirdStory.x86"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	einfo "unpacking data..."
	unzip -qo "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/${PN}"

	rm -r "${S}"/game/linux_launcher.sh \
		"${S}"/game/lib$(usex amd64 "" "64") \
		"${S}"/game/ABirdStory.$(usex amd64 "x86" "amd64") || die

	find "${S}"/game/lib$(usex amd64 "64" "") -type f \
		! -name "libphysfs.so.1" \
		! -name "libruby.so.2.1" \
		! -name "libSDL_sound-1.0.so.1" \
		-delete || die

	dodir "${dir}"
	mv "${S}/game" "${D}${dir}/" || die

	fperms 0755 "${dir}"/game/ABirdStory.$(usex amd64 "amd64" "x86") \
		"${dir}"/game/lib$(usex amd64 "64" "")/{libphysfs.so.1,libruby.so.2.1,libSDL_sound-1.0.so.1}

	make_wrapper ${PN} "./ABirdStory.$(usex amd64 "amd64" "x86")" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "A Bird Story"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
