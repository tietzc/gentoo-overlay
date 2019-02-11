# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg-utils

DESCRIPTION="Grim Fandango: Remastered"
HOMEPAGE="https://www.gog.com/game/grim_fandango_remastered"
SRC_URI="gog_grim_fandango_remastered_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+savedir-patch"
RESTRICT="bindist fetch"

# use bundled dev-lang/lua for now

RDEPEND="
	dev-libs/expat[abi_x86_32(-)]
	media-libs/libsdl2[abi_x86_32(-),X,opengl,sound,video]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]"

BDEPEND="
	app-arch/unzip
	savedir-patch? ( dev-util/xdelta:3 )"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/gog/${PN}/GrimFandango
	opt/gog/${PN}/libchore.so
	opt/gog/${PN}/libLua.so"

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
	local ABI="x86"

	rm -r game/run.sh \
		game/bin/amd64 \
		game/bin/common-licenses \
		game/bin/i386 \
		game/bin/libSDL2-2.0.so.1 || die

	insinto "${dir}"
	doins -r game/bin/.

	dosym ../../../usr/$(get_libdir)/libSDL2.so "${dir}"/libSDL2-2.0.so.1

	if use savedir-patch; then
		pushd "${D}/${dir}" >/dev/null || die
		xdelta3 -d -s GrimFandango "${FILESDIR}"/SaveDir-Patch.xdelta3 GrimFandango.new || die
		mv GrimFandango.new GrimFandango || die
		popd >/dev/null || die
	fi

	fperms +x "${dir}"/GrimFandango

	make_wrapper ${PN} "./GrimFandango" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Grim Fandango: Remastered"
}

pkg_postinst() {
	xdg_icon_cache_update

	if ! use savedir-patch; then
		elog "You did not enable 'savedir-patch' USE flag."
		elog "Saving configuration and savegames will not work."
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}
