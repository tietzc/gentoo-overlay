# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="Doom 3 GPL source modification"
HOMEPAGE="https://github.com/dhewm/dhewm3"
SRC_URI="https://github.com/dhewm/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dedicated"

RDEPEND="
	media-libs/libsdl3[opengl]
	media-libs/openal
	net-misc/curl
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

CMAKE_USE_DIR="${S}/neo"

DOCS=( ../{Changelog,README}.md )

src_configure() {
	local mycmakeargs=(
		-DBASE=$(usex dedicated OFF ON)
		-DCORE=$(usex dedicated OFF ON)
		-DD3XP=$(usex dedicated OFF ON)
		-DDEDICATED=$(usex dedicated ON OFF)
		-DSDL2=OFF
		-DSDL3=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if ! use dedicated; then
		doicon dist/linux/share/icons/hicolor/scalable/apps/org.${PN}.Dhewm3.svg
		domenu dist/linux/share/applications/org.${PN}.Dhewm3.desktop
		domenu dist/linux/share/applications/org.${PN}.Dhewm3.d3xp.desktop
	fi
}
