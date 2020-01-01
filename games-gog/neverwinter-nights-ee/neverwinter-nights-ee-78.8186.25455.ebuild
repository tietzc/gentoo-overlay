# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg

DESCRIPTION="Neverwinter Nights: Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/neverwinter_nights_enhanced_edition_pack"

DE_SRC_URI="neverwinter_nights_enhanced_edition_german_${PV//./_}.sh"
EN_SRC_URI="neverwinter_nights_enhanced_edition_${PV//./_}.sh"
ES_SRC_URI="neverwinter_nights_enhanced_edition_spanish_${PV//./_}.sh"
FR_SRC_URI="neverwinter_nights_enhanced_edition_french_${PV//./_}.sh"
IT_SRC_URI="neverwinter_nights_enhanced_edition_italian_${PV//./_}.sh"
PL_SRC_URI="neverwinter_nights_enhanced_edition_polish_${PV//./_}.sh"
SRC_URI="
	l10n_de? ( ${DE_SRC_URI} )
	l10n_en? ( ${EN_SRC_URI} )
	l10n_es? ( ${ES_SRC_URI} )
	l10n_fr? ( ${FR_SRC_URI} )
	l10n_it? ( ${IT_SRC_URI} )
	l10n_pl? ( ${PL_SRC_URI} )"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="l10n_de l10n_en l10n_es l10n_fr l10n_it l10n_pl"
REQUIRED_USE="^^ ( ${IUSE} )"
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/expat[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch"

QA_PREBUILT="
	opt/gog/${PN}/bin/linux/nwmain-linux
	opt/gog/${PN}/bin/linux/nwserver-linux"

pkg_nofetch() {
	einfo "Please buy & download"
	use l10n_de && einfo "\"${DE_SRC_URI}\""
	use l10n_en && einfo "\"${EN_SRC_URI}\""
	use l10n_es && einfo "\"${ES_SRC_URI}\""
	use l10n_fr && einfo "\"${FR_SRC_URI}\""
	use l10n_it && einfo "\"${IT_SRC_URI}\""
	use l10n_pl && einfo "\"${PL_SRC_URI}\""
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
	use l10n_pl && unpack_zip "${DISTDIR}/${PL_SRC_URI}"
}

src_install() {
	local dir="/opt/gog/${PN}"

	insinto "${dir}"
	doins -r game/.

	fperms +x "${dir}"/bin/linux/nwmain-linux

	make_wrapper ${PN} "./nwmain-linux" "${dir}"/bin/linux
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Neverwinter Nights: Enhanced Edition"
}
