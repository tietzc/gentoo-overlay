# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils virtualx xdg-utils

DESCRIPTION="Interactive post-processing tool for scanned pages"
HOMEPAGE="https://github.com/4lex4/scantailor-advanced"
SRC_URI="https://github.com/4lex4/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/libpng:0=
	media-libs/tiff:0=
	sys-libs/zlib:=
	virtual/jpeg:0=
	x11-libs/libXrender"

DEPEND="${RDEPEND}
	dev-libs/boost
	dev-qt/linguist-tools:5
	!media-gfx/scantailor"

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	virtx emake test
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}