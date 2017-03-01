# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs eutils gnome2-utils unpacker

DESCRIPTION="Soma"
HOMEPAGE="https://www.gog.com/game/soma"
SRC_URI="gog_soma_${PV}.sh"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""
RESTRICT="bindist fetch"

# use bundled dev-games/newton, dev-libs/angelscript, and media-libs/fmod for now

RDEPEND="
	|| (
		media-libs/libtxc_dxtn
		x11-drivers/nvidia-drivers
	)
	media-libs/devil[jpeg,png]
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libtheora
	media-libs/libvorbis"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

CHECKREQS_DISK_BUILD="22G"

QA_PREBUILT="
	opt/${PN}/game/ModLauncher.bin.x86_64
	opt/${PN}/game/Soma.bin.x86_64
	opt/${PN}/game/lib64/lib*"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	einfo "unpacking data..."
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/${PN}"

	find "${S}"/game/lib64 -type f \
		! -name "libangelscript.a" \
		! -name "libfbxsdk-2012.2-static.a" \
		! -name "libfmod*" \
		! -name "libNewton.a" \
		-delete || die

	find "${S}"/game/lib64 -type l \
		! -name "libfmod*" \
		-delete || die

	dodir "${dir}"
	mv "${S}/game" "${D}${dir}/" || die

	make_wrapper ${PN} "./Soma.bin.x86_64" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Soma"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
