# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="435637606d65efe1098683d133f348eb06f8b852"
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
	virtual/ffmpeg
	virtual/jpeg:62"

DEPEND="${RDEPEND}
	dev-libs/rapidjson"

PATCHES=(
	"${FILESDIR}"/${PN}-libpng16.patch
	"${FILESDIR}"/${PN}-fix-system-libjpeg.patch
)

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
		-DUSE_SYSTEM_LIBJPEG=ON
		-DUSE_SYSTEM_LIBPNG=ON
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DUSE_SYSTEM_ZLIB=ON
		-Wno-dev
	)

	cmake-utils_src_configure
}

src_install() {
	newbin "${BUILD_DIR}"/RBDoom3BFG ${PN}
	dolib.so "${BUILD_DIR}"/idlib/libidlib.so

	insinto /usr/share/games/doom3bfg/base
	doins base/{default,extract_resources}.cfg

	einstalldocs

	cat <<- EOF >> "${D}"/usr/share/games/doom3bfg/base/default.cfg
		//
		// Set default language to English
		//
		seta sys_lang "english"
	EOF
}
