# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="7eddea53f574da860fa36909fe06ad5b37ea2031"
MY_PN="RBDOOM-3-BFG"

inherit cmake

DESCRIPTION="Doom 3 BFG GPL source modification"
HOMEPAGE="https://github.com/RobertBeckebans/RBDOOM-3-BFG"
SRC_URI="https://github.com/RobertBeckebans/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	media-libs/glew:0=
	media-libs/libpng:=
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/openal:=
	media-video/ffmpeg:=
	sys-libs/zlib:=
	virtual/jpeg
"
DEPEND="
	${RDEPEND}
	dev-libs/rapidjson
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-fix-includepath.patch )

DOCS=( README.md RELEASE-NOTES.md )

S="${WORKDIR}/${MY_PN}-${COMMIT}"

CMAKE_USE_DIR="${S}"/neo

src_prepare() {
	# fix build with system-jpeg
	sed -i -e "/#define JPEG_INTERNALS/d" neo/renderer/Cinematic.cpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBINKDEC=OFF
		-DBUILD_SHARED_LIBS=OFF
		-DCPU_OPTIMIZATION=
		-DFFMPEG=ON
		-DOPENAL=ON
		-DOpenGL_GL_PREFERENCE=GLVND
		-DSDL2=ON
		-DUSE_PRECOMPILED_HEADERS=OFF
		-DUSE_SYSTEM_LIBGLEW=ON
		-DUSE_SYSTEM_LIBJPEG=ON
		-DUSE_SYSTEM_LIBPNG=ON
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DUSE_SYSTEM_ZLIB=ON
	)

	cmake_src_configure
}

src_install() {
	newbin "${BUILD_DIR}"/RBDoom3BFG ${PN}

	insinto /usr/share/games/doom3bfg/base
	doins base/{default,extract_resources}.cfg

	einstalldocs

	cat <<- EOF >> "${D}"/usr/share/games/doom3bfg/base/default.cfg
		//
		// Set default language to English
		//
		set sys_lang "english"
	EOF
}
