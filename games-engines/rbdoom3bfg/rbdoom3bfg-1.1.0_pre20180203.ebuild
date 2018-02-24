# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT="0e2890f923398761ddd571c817226ee888adce5c"
MY_PN="RBDOOM-3-BFG"

inherit cmake-utils

DESCRIPTION="Doom 3 BFG GPL source modification"
HOMEPAGE="https://github.com/RobertBeckebans/RBDOOM-3-BFG"
SRC_URI="https://github.com/RobertBeckebans/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	media-libs/glew:=
	media-libs/libpng:=
	media-libs/libsdl2[X,opengl,sound,video]
	>=media-libs/mesa-17.2
	media-libs/openal:=
	sys-libs/zlib:=[minizip]
	virtual/ffmpeg"

DEPEND="${RDEPEND}
	dev-libs/rapidjson"

PATCHES=(
	"${FILESDIR}"/libpng16.patch
	"${FILESDIR}"/system-rapidjson.patch
)

DOCS=( README.txt RELEASE-NOTES.txt )

S="${WORKDIR}/${MY_PN}-${COMMIT}"

CMAKE_USE_DIR="${S}"/neo

src_configure() {
	local mycmakeargs=(
		-DOPENAL=ON
		-DSDL2=ON
		-DUSE_PRECOMPILED_HEADERS=OFF
		-DUSE_SYSTEM_LIBGLEW=ON
		-DUSE_SYSTEM_LIBJPEG=OFF # needs jpegint.h
		-DUSE_SYSTEM_LIBPNG=ON
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DUSE_SYSTEM_ZLIB=ON
		-Wno-dev ../neo
	)

	cmake-utils_src_configure
}

src_install() {
	GAMES_DATADIR="/usr/share/games/doom3bfg"

	dobin "${BUILD_DIR}"/RBDoom3BFG

	insinto "${GAMES_DATADIR}"/base
	doins base/{default,extract_resources}.cfg

	einstalldocs

	cat <<- EOF >> "${D%/}/${GAMES_DATADIR}/base/default.cfg"
		//
		// Set default language to English
		//
		seta sys_lang "english"
	EOF
}
