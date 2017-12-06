# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils qmake-utils

DESCRIPTION="Easy to use screencast creator"
HOMEPAGE="https://github.com/vkohaupt/vokoscreen"
SRC_URI="https://github.com/vkohaupt/${PN}/archive/${PV}-beta.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	sys-process/lsof
	virtual/ffmpeg
	x11-libs/libXrandr"

DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

DOCS=( AUTHORS CHANGE README.md )

S="${WORKDIR}/${P}-beta"

src_configure() {
	"$(qt5_get_bindir)"/lrelease vokoscreen.pro || die "lrelease failed"
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
