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

	case ${ARCH} in
		amd64)
			rm -r \
				"${S}"/game/bin/lib32 \
				"${S}"/game/bin/lib64/libSDL* \
				"${S}"/game/bin/ninja-bin \
				"${S}"/game/bin/ninja-bin32 || die
			make_wrapper ${PN} "./ninja-bin64" "${dir}/game/bin"
			;;
		x86)
			rm -r \
				"${S}"/game/bin/lib32/libSDL* \
				"${S}"/game/bin/lib64 \
				"${S}"/game/bin/ninja-bin \
				"${S}"/game/bin/ninja-bin64 || die
			make_wrapper ${PN} "./ninja-bin32" "${dir}/game/bin"
			;;
	esac

	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Mark Of The Ninja: Special Edition"

	dodir "${dir}"
	mv "${S}/game" "${D}${dir}/" || die
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
