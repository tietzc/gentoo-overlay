# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
	dtoa-0.4.2
	getopts-0.2.15
	itoa-0.3.4
	libc-0.2.35
	num-traits-0.1.41
	quote-0.3.15
	serde-1.0.27
	serde_derive-1.0.27
	serde_derive_internals-0.19.0
	serde_json-1.0.9
	syn-0.11.11
	synom-0.11.3
	unicode-xid-0.0.4"

inherit cargo cmake-utils flag-o-matic gnome2-utils

DESCRIPTION="A port of Jagged Alliance 2 to SDL"
HOMEPAGE="https://ja2-stracciatella.github.io https://github.com/ja2-stracciatella/ja2-stracciatella"
SRC_URI="$(cargo_crate_uris ${CRATES})
	https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-libs/boost:=
	media-libs/libsdl2[X,opengl,sound,video]
	x11-libs/fltk"

DEPEND="${RDEPEND}
	dev-libs/rapidjson"

PATCHES=( "${FILESDIR}"/${PN}-only-use-release-profile.patch )

DOCS=( README.md changes.md contributors.txt )

GAMES_DATADIR="/usr/share/ja2"

src_unpack() {
	default
	cargo_src_unpack
}

src_prepare() {
	sed -i \
		-e "s:/some/place/where/the/data/is:${GAMES_DATADIR}:g" \
		rust/src/stracciatella.rs || die

	mkdir "${PORTAGE_BUILDDIR}"/homedir/.cargo || die
	cp "${WORKDIR}"/cargo_home/config "${PORTAGE_BUILDDIR}"/homedir/.cargo/config || die

	cmake-utils_src_prepare
}

src_configure() {
	append-cppflags "-I/usr/include/fltk"

	local mycmakeargs=(
		-DBUILD_LAUNCHER=ON
		-DEXTRA_DATA_DIR="${GAMES_DATADIR}"
		-DINSTALL_LIB_DIR="/usr/$(get_libdir)"
		-DLOCAL_BOOST_LIB=OFF
		-DLOCAL_GTEST_LIB=OFF
		-DLOCAL_RAPIDJSON_LIB=OFF
		-DLOCAL_SDL_LIB=OFF
		-DWITH_FIXMES=OFF
		-DWITH_MAEMO=OFF
		-DWITH_UNITTESTS=OFF
	)

	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	keepdir "${GAMES_DATADIR}"/data
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
