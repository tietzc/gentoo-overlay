# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="Mark of the Ninja: Special Edition"
HOMEPAGE="https://www.gog.com/game/mark_of_the_ninja_special_edition"

BASE_SRC_URI="gog_mark_of_the_ninja_${PV}.sh"
DLC_SRC_URI="gog_mark_of_the_ninja_special_edition_dlc_2.0.0.4.sh"
SRC_URI="${BASE_SRC_URI}
	dlc? ( ${DLC_SRC_URI} )"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+dlc"
RESTRICT="bindist fetch"

# use bundled media-libs/fmod for now

RDEPEND="
	dev-libs/expat
	media-libs/libsdl[X,opengl,sound,video]
	media-libs/libvorbis
	media-libs/openal"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/motn/bin/lib*/lib*
	opt/motn/bin/ninja-bin*"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use dlc && einfo "and \"${DLC_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	unzip -qo "${DISTDIR}/${BASE_SRC_URI}"

	if use dlc ; then
		unzip -qo "${DISTDIR}/${DLC_SRC_URI}"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	rm -r game/bin/lib$(usex amd64 "32" "64") \
		game/bin/lib$(usex amd64 "64" "32")/libSDL* \
		game/bin/ninja-bin \
		game/bin/ninja-bin$(usex amd64 "32" "64") || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/bin/ninja-bin$(usex amd64 "64" "32")

	make_wrapper ${PN} "./ninja-bin$(usex amd64 "64" "32")" "${dir}/bin"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Mark Of The Ninja: Special Edition"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
