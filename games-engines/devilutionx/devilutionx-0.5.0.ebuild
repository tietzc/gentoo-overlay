# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
MY_PN="devilutionX"

inherit cmake-utils desktop xdg

DESCRIPTION="Diablo build for modern operating systems"
HOMEPAGE="https://github.com/diasurgical/devilutionX"
SRC_URI="https://github.com/diasurgical/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-libs/libsodium
	media-libs/libsdl2[X,haptic,opengl,sound,video]
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	eapply -R "${FILESDIR}"/${PN}-facebookincubator_find_libsodium.patch

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBINARY_RELEASE=ON
		-DDEBUG=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/${PN}

	newicon -s 48 Packaging/resources/Diablo_48.png ${PN}.png
	make_desktop_entry ${PN} "Diablo"
}
