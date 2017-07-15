# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="Jotun: Valhalla Edition"
HOMEPAGE="https://www.gog.com/game/jotun"
SRC_URI="gog_jotun_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/atk
	media-libs/fontconfig
	media-libs/freetype:2
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/${PN}/game/Jotun.x86*
	opt/${PN}/game/Jotun_Data/Mono/x86*/libmono.so"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	einfo "unpacking data..."
	unzip -qo "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/${PN}"

	rm -r "${S}"/game/Jotun.x86$(usex amd64 "" "_64") \
		"${S}"/game/Jotun_Data/Mono/$(usex amd64 "x86" "x86_64") \
		"${S}"/game/Jotun_Data/Plugins/$(usex amd64 "x86" "x86_64") || die

	insinto "${dir}"
	doins -r game

	fperms +x "${dir}"/game/Jotun.x86$(usex amd64 "_64" "")

	make_wrapper ${PN} "./Jotun.x86$(usex amd64 "_64" "")" "${dir}/game"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Jotun: Valhalla Edition"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
