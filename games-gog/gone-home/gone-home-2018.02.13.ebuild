# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker versionator

DESCRIPTION="Gone Home"
HOMEPAGE="https://www.gog.com/game/gone_home"
SRC_URI="gone_home_en_$(version_format_string '$3_$2_$1')_update_18660.sh"

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
	opt/gog/${PN}/GoneHome_linux.x86*
	opt/gog/${PN}/GoneHome_linux_Data/Mono/x86*/libmono.so"

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

	rm -r game/GoneHome_linux.$(usex amd64 "x86" "x86_64") \
		game/GoneHome_linux_Data/Mono/$(usex amd64 "x86" "x86_64") \
		game/GoneHome_linux_Data/Plugins/x86{,_64}/libsteam_api.so || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/GoneHome_linux.$(usex amd64 "x86_64" "x86")

	make_wrapper ${PN} "./GoneHome_linux.$(usex amd64 "x86_64" "x86")" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Gone Home"

	# work around localization issue
	sed -i '2i\export LC_ALL=C\' "${D%/}/usr/bin/${PN}" || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
