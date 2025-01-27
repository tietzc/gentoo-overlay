# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper xdg

DESCRIPTION="The Curse of Monkey Island"
HOMEPAGE="https://www.gog.com/game/the_curse_of_monkey_island"

DE_SRC_URI="
	setup_the_curse_of_monkey_islandtm_${PV}_(german)_(20628).exe
	setup_the_curse_of_monkey_islandtm_${PV}_(german)_(20628)-1.bin
"
EN_SRC_URI="
	setup_the_curse_of_monkey_islandtm_${PV}_(20628).exe
	setup_the_curse_of_monkey_islandtm_${PV}_(20628)-1.bin
"
ES_SRC_URI="
	setup_the_curse_of_monkey_islandtm_${PV}_(spanish)_(20628).exe
	setup_the_curse_of_monkey_islandtm_${PV}_(spanish)_(20628)-1.bin
"
FR_SRC_URI="
	setup_the_curse_of_monkey_islandtm_${PV}_(french)_(20628).exe
	setup_the_curse_of_monkey_islandtm_${PV}_(french)_(20628)-1.bin
"
IT_SRC_URI="
	setup_the_curse_of_monkey_islandtm_${PV}_(italian)_(20628).exe
	setup_the_curse_of_monkey_islandtm_${PV}_(italian)_(20628)-1.bin
"

SRC_URI="
	l10n_de? ( ${DE_SRC_URI} )
	l10n_en? ( ${EN_SRC_URI} )
	l10n_es? ( ${ES_SRC_URI} )
	l10n_fr? ( ${FR_SRC_URI} )
	l10n_it? ( ${IT_SRC_URI} )
"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="l10n_de l10n_en l10n_es l10n_fr l10n_it"
REQUIRED_USE="^^ ( ${IUSE} )"
RESTRICT="bindist fetch"

RDEPEND="
	games-engines/scummvm
"
BDEPEND="
	>=app-arch/innoextract-1.7
	media-gfx/icoutils
"

S="${WORKDIR}"

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
	use l10n_de && innoextract "${DISTDIR}/setup_the_curse_of_monkey_islandtm_${PV}_(german)_(20628).exe"
	use l10n_en && innoextract "${DISTDIR}/setup_the_curse_of_monkey_islandtm_${PV}_(20628).exe"
	use l10n_es && innoextract "${DISTDIR}/setup_the_curse_of_monkey_islandtm_${PV}_(spanish)_(20628).exe"
	use l10n_fr && innoextract "${DISTDIR}/setup_the_curse_of_monkey_islandtm_${PV}_(french)_(20628).exe"
	use l10n_it && innoextract "${DISTDIR}/setup_the_curse_of_monkey_islandtm_${PV}_(italian)_(20628).exe"
}

src_install() {
	local dir="/opt/gog/${PN}"

	icotool -x app/goggame-1528148981.ico || die

	insinto "${dir}"
	doins -r RESOURCE COMI.LA0 COMI.LA1 COMI.LA2

	dodoc Guide.pdf

	make_wrapper ${PN} "scummvm -f -p "${dir}" comi"
	newicon -s 256 goggame-1528148981_7_256x256x32.png ${PN}.png
	make_desktop_entry ${PN} "The Curse Of Monkey Island"
}
