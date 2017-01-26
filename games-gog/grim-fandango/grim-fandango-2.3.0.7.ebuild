# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Grim Fandango: Remastered"
HOMEPAGE="https://www.gog.com/game/grim_fandango_remastered"
SRC_URI="gog_grim_fandango_remastered_${PV}.sh"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

# use bundled dev-lang/lua for now

RDEPEND="
	dev-libs/expat[abi_x86_32(-)]
	media-libs/libsdl2[abi_x86_32(-),X,opengl,sound,video]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/${PN}/game/bin/GrimFandango
	opt/${PN}/game/bin/libchore.so
	opt/${PN}/game/bin/libLua.so"

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

	rm -r \
		"${S}"/game/bin/amd64 \
		"${S}"/game/bin/i386 \
		"${S}"/game/bin/libSDL2-2.0.so.1 || die

	dodir "${dir}"
	mv "${S}/game" "${D}${dir}/" || die

	dosym /usr/$(get_abi_LIBDIR x86)/libSDL2-2.0.so.0 "${dir}"/game/bin/libSDL2-2.0.so.1

	# really ugly hack to work around savedir issue
	dodir "${dir}"/game/bin/Saves
	fperms 0777 "${dir}"/game/bin/Saves

	make_wrapper ${PN} "./run.sh" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Grim Fandango: Remastered"
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
