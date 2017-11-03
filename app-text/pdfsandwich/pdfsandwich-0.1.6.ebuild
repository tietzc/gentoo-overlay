# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool to generate 'sandwich' OCR pdf files"
HOMEPAGE="http://www.tobias-elze.de/pdfsandwich"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	app-text/ghostscript-gpl
	app-text/poppler[png,utils]
	app-text/tesseract
	app-text/unpaper
	media-gfx/exact-image
	virtual/imagemagick-tools[png]"

DEPEND="
	dev-lang/ocaml[ocamlopt]
	sys-apps/gawk"

src_prepare() {
	default

	sed -i "/^OCAMLOPTFLAGS/s/$/ -ccopt \"\$(CFLAGS) \$(LDFLAGS)\"/" Makefile || die
	sed -i "s/install -s/install/" Makefile || die
}
