# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="The Dig"
HOMEPAGE="https://www.gog.com/game/the_dig"

DE_SRC_URI="the_dig_de_gog_${PV//./_}.sh"
EN_SRC_URI="the_dig_en_gog_${PV//./_}.sh"
ES_SRC_URI="the_dig_es_gog_${PV//./_}.sh"
FR_SRC_URI="the_dig_fr_gog_${PV//./_}.sh"
IT_SRC_URI="the_dig_it_gog_${PV//./_}.sh"
SRC_URI="
	l10n_de? ( ${DE_SRC_URI} )
	l10n_en? ( ${EN_SRC_URI} )
	l10n_es? ( ${ES_SRC_URI} )
	l10n_fr? ( ${FR_SRC_URI} )
	l10n_it? ( ${IT_SRC_URI} )"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_de l10n_en l10n_es l10n_fr l10n_it"
REQUIRED_USE="^^ ( ${IUSE} )"
RESTRICT="bindist fetch"

RDEPEND="games-engines/scummvm"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo "Please buy & download"
	use l10n_de && einfo "\"${DE_SRC_URI}\""
	use l10n_en && einfo "\"${EN_SRC_URI}\""
	use l10n_es && einfo "\"${ES_SRC_URI}\""
	use l10n_fr && einfo "\"${FR_SRC_URI}\""
	use l10n_it && einfo "\"${IT_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	use l10n_de && unpack_zip "${DISTDIR}/${DE_SRC_URI}"
	use l10n_en && unpack_zip "${DISTDIR}/${EN_SRC_URI}"
	use l10n_es && unpack_zip "${DISTDIR}/${ES_SRC_URI}"
	use l10n_fr && unpack_zip "${DISTDIR}/${FR_SRC_URI}"
	use l10n_it && unpack_zip "${DISTDIR}/${IT_SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	insinto "${dir}"
	doins -r data/.

	make_wrapper ${PN} "scummvm -f -p "${dir}" dig"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "The Dig"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}