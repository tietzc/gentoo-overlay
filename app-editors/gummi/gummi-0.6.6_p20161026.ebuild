# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

COMMIT="8887f09fafe200c2602a94413d9350013fd97c6a"

DESCRIPTION="Simple LaTeX editor for GTK+ users"
HOMEPAGE="https://github.com/alexandervdm/gummi"
SRC_URI="https://github.com/alexandervdm/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

LANGS="ar ca cs da de el es fr hu it nl pl pt pt_BR ro ru sv zh_CN zh_TW"

for X in ${LANGS} ; do
	IUSE+=" linguas_${X}"
done

RDEPEND="
	dev-libs/glib:2
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	x11-libs/gtk+:2"

DEPEND="${RDEPEND}
	app-text/gtkspell:2
	app-text/poppler[cairo]
	x11-libs/gtksourceview:2.0
	x11-libs/pango"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	strip-linguas ${LANGS}
	eautoreconf
}

pkg_postinst() {
	elog "Gummi supports spell-checking through gtkspell. Support for"
	elog "additional languages can be added by installing myspell-**"
	elog "packages for your language of choice."
}
