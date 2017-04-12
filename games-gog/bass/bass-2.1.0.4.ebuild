# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Beneath a Steel Sky"
HOMEPAGE="https://www.gog.com/game/beneath_a_steel_sky"
SRC_URI="gog_beneath_a_steel_sky_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_de l10n_es l10n_fr l10n_it"
RESTRICT="bindist fetch"

RDEPEND="games-engines/scummvm"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo
	einfo "Please download \"${SRC_URI}\" from:"
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

	insinto "${dir}"
	doins -r data/.

	newicon -s 256 support/icon.png ${PN}.png

	local i
	for i in de es fr it ; do
		if use l10n_${i} ; then
			make_wrapper "${PN}-${i}" "scummvm -f -p "${dir}" -q "${i}" sky"
			make_desktop_entry "${PN}-${i}" "Beneath A Steel Sky ("${i}")"
		else
			make_wrapper "${PN}" "scummvm -f -p "${dir}" sky"
			make_desktop_entry "${PN}" "Beneath A Steel Sky"
		fi
	done
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
