# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT="e9e1347a05d6d56f3c8322e449a212ca868115bb"
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
	media-libs/openal:=
	sys-libs/zlib:=[minizip]
	virtual/ffmpeg"

DEPEND="${RDEPEND}
	dev-libs/rapidjson"

PATCHES=( "${FILESDIR}"/${PN}-libpng16.patch )

DOCS=( README.txt RELEASE-NOTES.txt )

S="${WORKDIR}/${MY_PN}-${COMMIT}"

CMAKE_USE_DIR="${S}"/neo

src_configure() {
	local mycmakeargs=(
		-DBINKDEC=OFF
		-DFFMPEG=ON
		-DOPENAL=ON
		-DSDL2=ON
		-DUSE_PRECOMPILED_HEADERS=OFF
		-DUSE_SYSTEM_LIBGLEW=ON
		-DUSE_SYSTEM_LIBJPEG=OFF # needs jpegint.h
		-DUSE_SYSTEM_LIBPNG=ON
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DUSE_SYSTEM_ZLIB=ON
		-Wno-dev
	)

	cmake-utils_src_configure
}

src_install() {
	newbin "${BUILD_DIR}"/RBDoom3BFG ${PN}

	insinto /usr/share/games/doom3bfg/base
	doins base/{default,extract_resources}.cfg

	einstalldocs

	cat <<- EOF >> "${D%/}"/usr/share/games/doom3bfg/base/default.cfg
		//
		// Set default language to English
		//
		seta sys_lang "english"
	EOF
}
