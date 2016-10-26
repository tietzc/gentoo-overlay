# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Mark of the Ninja: Special Edition"
HOMEPAGE="https://www.gog.com/game/mark_of_the_ninja_special_edition"

BASE_SRC_URI="gog_mark_of_the_ninja_${PV}.sh"
DLC_SRC_URI="gog_mark_of_the_ninja_special_edition_dlc_2.0.0.4.sh"
SRC_URI="${BASE_SRC_URI}
	dlc? ( ${DLC_SRC_URI} )"

LICENSE="all-rights-reserved GOG-EULA"
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
	opt/motn/game/bin/lib*/lib*
	opt/motn/game/bin/ninja-bin*"

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
	einfo "unpacking base data..."
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"

	if use dlc ; then
		einfo "unpacking dlc data..."
		unpack_zip "${DISTDIR}/${DLC_SRC_URI}"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	dodir "${dir}"
	rm -r \
		"${S}"/game/bin/lib$(usex amd64 "32" "64") \
		"${S}"/game/bin/lib$(usex amd64 "64" "32")/libSDL* \
		"${S}"/game/bin/ninja-bin \
		"${S}"/game/bin/ninja-bin$(usex amd64 "32" "64") || die
	mv "${S}/game" "${D}${dir}/" || die

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Mark Of The Ninja: Special Edition"
	make_wrapper ${PN} "./ninja-bin$(usex amd64 "64" "32")" "${dir}/game/bin"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}