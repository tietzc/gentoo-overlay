# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils qmake-utils

DESCRIPTION="Easy to use screencast creator"
HOMEPAGE="https://github.com/vkohaupt/vokoscreen"
SRC_URI="https://github.com/vkohaupt/${PN}/archive/${PV}-beta.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pulseaudio +v4l +vpx +x265"
RESTRICT="mirror"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[pulseaudio?,widgets]
	dev-qt/qtnetwork:5
	dev-qt/qtx11extras:5
	media-video/ffmpeg[encode,mp3,pulseaudio?,v4l?,vorbis,vpx?,x264,x265?]
	sys-process/lsof
	x11-libs/libX11"

DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qttest:5
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
