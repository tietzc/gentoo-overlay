# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools vcs-snapshot

COMMIT="e6134ec1dbd96bb455c9daa4c35e615118092c4f"

DESCRIPTION="Simple LaTeX editor for GTK+ users"
HOMEPAGE="https://github.com/aitjcize/gummi"
SRC_URI="https://github.com/aitjcize/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-libs/glib:2
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	x11-libs/gtk+:3"

DEPEND="${RDEPEND}
	app-text/gtkspell:3
	app-text/poppler[cairo]
	x11-libs/gtksourceview:3.0
	x11-libs/pango"

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	elog "Gummi supports spell-checking through gtkspell. Support for"
	elog "additional languages can be added by installing myspell-**"
	elog "packages for your language of choice."
}
