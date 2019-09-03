# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="devilutionX"

inherit cmake-utils desktop multilib xdg

DESCRIPTION="Diablo build for modern operating systems"
HOMEPAGE="https://github.com/diasurgical/devilutionX"
SRC_URI="https://github.com/diasurgical/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-libs/libsodium[abi_x86_32(-)]
	media-libs/libsdl2[abi_x86_32(-),X,haptic,opengl,sound,video]
	media-libs/sdl2-mixer[abi_x86_32(-)]
	media-libs/sdl2-ttf[abi_x86_32(-)]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	media-gfx/icoutils
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default
	cmake-utils_src_prepare
}

src_configure() {
	use amd64 && multilib_toolchain_setup x86

	local mycmakeargs=(
		-DBINARY_RELEASE=ON
		-DDEBUG=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/${PN}

	icotool -x Diablo.ico || die

	newicon -s 32 Diablo_1_32x32x4.png ${PN}.png
	make_desktop_entry ${PN} "Diablo"
}
