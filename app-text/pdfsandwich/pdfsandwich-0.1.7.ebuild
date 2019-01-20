# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tool to generate 'sandwich' OCR pdf files"
HOMEPAGE="http://www.tobias-elze.de/pdfsandwich"
SRC_URI="https://sourceforge.net/projects/${PN}/files/${PN}%20${PV}/${P}.tar.bz2"

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

BDEPEND="dev-lang/ocaml[ocamlopt]"

src_prepare() {
	default

	sed -i \
		-e "/^OCAMLOPTFLAGS/s/$/ -ccopt \"\$(CFLAGS) \$(LDFLAGS)\"/" \
		-e "s/install -s/install/" \
		Makefile || die
}
