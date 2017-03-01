# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils unpacker

DESCRIPTION="Sam & Max Hit the Road"
HOMEPAGE="https://www.gog.com/game/sam_max_hit_the_road"

DE_SRC_URI="gog_sam_max_hit_the_road_german_${PV}.sh"
EN_SRC_URI="gog_sam_max_hit_the_road_${PV}.sh"
ES_SRC_URI="gog_sam_max_hit_the_road_spanish_${PV}.sh"
FR_SRC_URI="gog_sam_max_hit_the_road_french_${PV}.sh"
IT_SRC_URI="gog_sam_max_hit_the_road_italian_${PV}.sh"
SRC_URI="
	l10n_de? ( ${DE_SRC_URI} )
	l10n_en? ( ${EN_SRC_URI} )
	l10n_es? ( ${ES_SRC_URI} )
	l10n_fr? ( ${FR_SRC_URI} )
	l10n_it? ( ${IT_SRC_URI} )"

LICENSE="all-rights-reserved GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_de l10n_en l10n_es l10n_fr l10n_it"
REQUIRED_USE="^^ ( ${IUSE} )"
RESTRICT="bindist fetch"

RDEPEND="games-engines/scummvm"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo
	einfo "Please buy & download"
	use l10n_de && einfo "\"${DE_SRC_URI}\""
	use l10n_en && einfo "\"${EN_SRC_URI}\""
	use l10n_es && einfo "\"${ES_SRC_URI}\""
	use l10n_fr && einfo "\"${FR_SRC_URI}\""
	use l10n_it && einfo "\"${IT_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	if use l10n_de ; then
		einfo "unpacking l10n_de data..."
		unpack_zip "${DISTDIR}/${DE_SRC_URI}"
	fi

	if use l10n_en ; then
		einfo "unpacking l10n_en data..."
		unpack_zip "${DISTDIR}/${EN_SRC_URI}"
	fi

	if use l10n_es ; then
		einfo "unpacking l10n_es data..."
		unpack_zip "${DISTDIR}/${ES_SRC_URI}"
	fi

	if use l10n_fr ; then
		einfo "unpacking l10n_fr data..."
		unpack_zip "${DISTDIR}/${FR_SRC_URI}"
	fi

	if use l10n_it ; then
		einfo "unpacking l10n_it data..."
		unpack_zip "${DISTDIR}/${IT_SRC_URI}"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r data/.

	make_wrapper "${PN}" "scummvm -f -p "${dir}" samnmax"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry "${PN}" "Sam & Max Hit The Road"
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