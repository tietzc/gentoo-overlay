# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs eutils gnome2-utils unpacker

DESCRIPTION="Soma"
HOMEPAGE="https://www.gog.com/game/soma"
SRC_URI="gog_soma_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""
RESTRICT="bindist fetch"

# use bundled dev-games/newton, dev-libs/angelscript, and media-libs/fmod for now

RDEPEND="
	dev-libs/expat
	media-libs/devil[jpeg,mng,png,tiff]
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libtheora
	media-libs/libvorbis
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	|| (
		media-libs/libtxc_dxtn
		x11-drivers/nvidia-drivers
	)"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

CHECKREQS_DISK_BUILD="22G"

QA_PREBUILT="
	opt/${PN}/ModLauncher.bin.x86_64
	opt/${PN}/Soma.bin.x86_64
	opt/${PN}/lib64/lib*"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/${PN}"

	find game/lib64 -type f \
		! -name "libangelscript.a" \
		! -name "libfbxsdk-2012.2-static.a" \
		! -name "libfmod*" \
		! -name "libNewton.a" \
		-delete || die

	find game/lib64 -type l \
		! -name "libfmod*" \
		-delete || die

	dodir "${dir}"
	mv game/* "${D%/}/${dir}" || die

	# ensure sane permissions
	find "${D%/}/${dir}" -type f -exec chmod 0644 '{}' + || die
	find "${D%/}/${dir}" -type d -exec chmod 0755 '{}' + || die
	fperms +x "${dir}"/Soma.bin.x86_64

	make_wrapper ${PN} "./Soma.bin.x86_64" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Soma"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
