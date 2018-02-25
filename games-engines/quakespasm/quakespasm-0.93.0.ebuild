# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils

DESCRIPTION="Unix-friendly Quake engine based on the popular FitzQuake"
HOMEPAGE="http://quakespasm.sourceforge.net"
SRC_URI="mirror://sourceforge/quakespasm/Source/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	media-libs/libmad
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libvorbis"

DEPEND="${RDEPEND}"

DOCS=( Quakespasm.txt )

src_prepare() {
	default

	# respect CFLAGS
	sed -i '/CFLAGS += -O2/d' Quake/Makefile || die

	# disable automatic stripping of binary
	sed -i '/\$(call cmd_strip,\$(1));/d' Quake/Makefile || die
}

src_compile() {
	cd Quake || die
	emake DO_USERDIRS=1 USE_SDL2=1
}

src_install() {
	dobin Quake/${PN}

	einstalldocs

	newicon -s 512 Misc/QuakeSpasm_512.png ${PN}.png
	make_desktop_entry ${PN} "Quakespasm"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
