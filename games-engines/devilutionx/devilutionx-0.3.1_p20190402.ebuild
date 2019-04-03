# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="fc9cb19ca4d831cc514e5c037cc0acb073603aed"
MY_PN="devilutionX"

inherit cmake-utils multilib

DESCRIPTION="Diablo build for modern operating systems"
HOMEPAGE="https://github.com/diasurgical/devilutionX"
SRC_URI="https://github.com/diasurgical/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-libs/libsodium[abi_x86_32]
	media-libs/libsdl2[abi_x86_32,X,haptic,opengl,sound,video]
	media-libs/sdl2-mixer[abi_x86_32]
	media-libs/sdl2-ttf[abi_x86_32]"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}-${COMMIT}"

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
}
