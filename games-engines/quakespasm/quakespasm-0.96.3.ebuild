# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Unix-friendly Quake engine based on the popular FitzQuake"
HOMEPAGE="http://quakespasm.sourceforge.net"
SRC_URI="https://sourceforge.net/projects/${PN}/files/Source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="flac mp3 opus vorbis"

RDEPEND="
	media-libs/libsdl2[X,opengl,sound,video]
	flac? ( media-libs/flac:= )
	mp3? ( media-libs/libmad:= )
	opus? ( media-libs/opus:= )
	vorbis? ( media-libs/libvorbis:= )
"
DEPEND="
	${RDEPEND}
"

DOCS=( Quakespasm.txt Quakespasm-Music.txt )

src_prepare() {
	default

	# respect CFLAGS
	sed -i -e "/CFLAGS += -O2/d" Quake/Makefile || die

	# disable automatic stripping of binary
	sed -i -e "/\$(call cmd_strip,\$(1));/d" Quake/Makefile || die
}

src_compile() {
	local myconf=(
		DO_USERDIRS=1
		USE_CODEC_FLAC=$(usex flac 1 0)
		USE_CODEC_MP3=$(usex mp3 1 0)
		USE_CODEC_OPUS=$(usex opus 1 0)
		USE_CODEC_VORBIS=$(usex vorbis 1 0)
		USE_CODEC_WAVE=1
		USE_SDL2=1
	)

	emake -C Quake "${myconf[@]}"
}

src_install() {
	dobin Quake/${PN}

	einstalldocs

	newicon -s 512 Misc/QuakeSpasm_512.png ${PN}.png
	make_desktop_entry ${PN} "Quakespasm"
}
