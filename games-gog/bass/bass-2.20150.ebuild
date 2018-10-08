# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Beneath a Steel Sky"
HOMEPAGE="https://www.gog.com/game/beneath_a_steel_sky"
SRC_URI="beneath_a_steel_sky_en_gog_${PV//./_}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_de l10n_es l10n_fr l10n_it"
RESTRICT="bindist fetch"

RDEPEND="games-engines/scummvm"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo "Please download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"
	local lang

	insinto "${dir}"
	doins -r data/.

	newicon -s 256 support/icon.png ${PN}.png

	for lang in de es fr it; do
		if use l10n_${lang}; then
			make_wrapper ${PN}-${i} "scummvm -f -p "${dir}" -q ${lang} sky"
			make_desktop_entry ${PN}-${lang} "Beneath A Steel Sky (${lang})"
		else
			make_wrapper ${PN} "scummvm -f -p "${dir}" sky"
			make_desktop_entry ${PN} "Beneath A Steel Sky"
		fi
	done
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
