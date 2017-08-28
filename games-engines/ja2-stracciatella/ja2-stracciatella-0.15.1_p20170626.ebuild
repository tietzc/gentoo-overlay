# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
	dtoa-0.2.2
	getopts-0.2.14
	itoa-0.1.1
	libc-0.2.21
	num-traits-0.1.37
	serde-0.8.23
	serde_json-0.8.6"

COMMIT="9ad6cf5e5b6742b5831382156e84cf0eb7ade11d"

inherit cargo cmake-utils gnome2-utils

DESCRIPTION="A port of Jagged Alliance 2 to SDL"
HOMEPAGE="https://ja2-stracciatella.github.io https://github.com/ja2-stracciatella/ja2-stracciatella"
SRC_URI="$(cargo_crate_uris ${CRATES})
	https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-libs/boost:=
	media-libs/libsdl2[X,opengl,sound,video]"

DEPEND="${RDEPEND}
	dev-util/cargo"

PATCHES=( "${FILESDIR}/Only-depend-on-release-packages.patch" )

DOCS=( README.md changes.md contributors.txt )

GAMES_DATADIR="/usr/share/ja2"

S="${WORKDIR}/${PN}-${COMMIT}"

src_unpack() {
	default
	cargo_src_unpack
}

src_prepare() {
	sed -i \
		-e "s:/some/place/where/the/data/is:${GAMES_DATADIR}:g" \
		rust/src/stracciatella.rs || die

	mkdir "${PORTAGE_BUILDDIR}/homedir/.cargo" || die
	cp "${WORKDIR}/cargo_home/config" "${PORTAGE_BUILDDIR}/homedir/.cargo/config" || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DEXTRA_DATA_DIR="${GAMES_DATADIR}"
		-DLOCAL_BOOST_LIB=OFF
		-DWITH_FIXMES=OFF
		-DWITH_MAEMO=OFF
		-DWITH_UNITTESTS=OFF
	)

	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	keepdir "${GAMES_DATADIR}/data"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
