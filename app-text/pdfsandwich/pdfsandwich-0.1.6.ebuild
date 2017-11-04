# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool to generate 'sandwich' OCR pdf files"
HOMEPAGE="http://www.tobias-elze.de/pdfsandwich"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	app-text/ghostscript-gpl
	app-text/poppler[png,utils]
	app-text/tesseract[osd,png]
	app-text/unpaper
	virtual/imagemagick-tools[png]"

DEPEND="dev-lang/ocaml[ocamlopt]"

src_prepare() {
	default

	sed -i \
		-e "/^OCAMLOPTFLAGS/s/$/ -ccopt \"\$(CFLAGS) \$(LDFLAGS)\"/" \
		-e "s/install -s/install/" \
		Makefile || die
}
