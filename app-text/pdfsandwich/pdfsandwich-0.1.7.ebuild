# Copyright 1999-2020 Gentoo Authors
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
	app-text/unpaper
	virtual/imagemagick-tools[png]
	|| (
		<=app-text/tesseract-4.0.0[osd,png]
		(
			>=app-text/tesseract-4.1.0[png]
			|| (
				>=app-text/tessdata_fast-4.0.0[osd]
				>=app-text/tessdata_best-4.0.0[osd]
				>=app-text/tessdata_legacy-4.0.0[osd]
			)
		)
	)"

BDEPEND="dev-lang/ocaml[ocamlopt]"

PATCHES=( "${FILESDIR}"/${PN}-no-manpages-and-docs-compression.patch )

src_prepare() {
	default

	# respect CFLAGS, LDFLAGS
	sed -i "/^OCAMLOPTFLAGS/s/$/ -ccopt \"\$(CFLAGS) \$(LDFLAGS)\"/" Makefile || die

	# disable automatic stripping of binary
	sed -i "s/install -s/install/" Makefile || die

	# fix docs install directory
	sed -i "/INSTALLDOCDIR/s/"\(TARGET\)/\(PF\)"/" Makefile || die
}
