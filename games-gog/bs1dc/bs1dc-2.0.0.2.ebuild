# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Broken Sword: Director's Cut"
HOMEPAGE="https://www.gog.com/game/broken_sword_directors_cut"
SRC_URI="gog_broken_sword_director_s_cut_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	media-libs/libsdl[X,opengl,sound,video]
	media-libs/libvorbis
	media-libs/openal
	x11-libs/libX11"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/gog/${PN}/bs1dc_i386
	opt/gog/${PN}/bs1dc_x86_64"

pkg_nofetch() {
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	mv game/$(usex amd64 "x86_64" "i386")/bs1dc_$(usex amd64 "x86_64" "i386") game/ || die

	rm -r game/{BS1DC,i386,x86_64} || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/bs1dc_$(usex amd64 "x86_64" "i386")

	make_wrapper ${PN} "./bs1dc_$(usex amd64 "x86_64" "i386")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Broken Sword: Director's Cut"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
