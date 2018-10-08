# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Torment: Tides of Numenera"
HOMEPAGE="https://www.gog.com/game/torment_tides_of_numenera"
SRC_URI="gog_torment_tides_of_numenera_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/atk
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libsdl2[X,opengl,sound,video]
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/gog/${PN}/TidesOfNumenera
	opt/gog/${PN}/TidesOfNumenera_Data/Mono/x86_64/libmono.so
	opt/gog/${PN}/TidesOfNumenera_Data/Plugins/libAkSoundEngine.so
	opt/gog/${PN}/TidesOfNumenera_Data/Plugins/x86_64/*.so"

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

	rm game/TidesOfNumenera_Data/Plugins/x86_64/libCSteamworks.so \
		game/TidesOfNumenera_Data/Plugins/x86_64/libsteam_api.so || die

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/TidesOfNumenera

	make_wrapper ${PN} "./TidesOfNumenera" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Torment: Tides Of Numenera"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
