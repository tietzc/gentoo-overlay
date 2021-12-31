# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs desktop unpacker wrapper xdg

DESCRIPTION="Pillars of Eternity II: Deadfire"
HOMEPAGE="https://www.gog.com/game/pillars_of_eternity_2_game"

BASE_SRC_URI="pillars_of_eternity_ii_deadfire_v${PV//./_}_29222.sh"
DE_SRC_URI="pillarsofeternity-2-german-patch-1.6.0.tar.gz"
DLC1_SRC_URI="pillars_of_eternity_ii_deadfire_beard_and_hair_pack_v${PV//./_}_29222.sh"
DLC2_SRC_URI="pillars_of_eternity_ii_deadfire_critical_role_pack_v${PV//./_}_29222.sh"
DLC3_SRC_URI="pillars_of_eternity_ii_deadfire_deck_of_many_things_v${PV//./_}_29222.sh"
DLC4_SRC_URI="pillars_of_eternity_ii_deadfire_explorer_s_pack_pet_cosmo_v${PV//./_}_29222.sh"
DLC5_SRC_URI="pillars_of_eternity_ii_deadfire_explorer_s_pack_tricorn_hat_v${PV//./_}_29222.sh"
DLC6_SRC_URI="pillars_of_eternity_ii_deadfire_rum_runner_s_pack_v${PV//./_}_29222.sh"
DLC7_SRC_URI="pillars_of_eternity_ii_deadfire_scalawag_pack_v${PV//./_}_29222.sh"
EXP1_SRC_URI="pillars_of_eternity_ii_deadfire_beast_of_winter_v${PV//./_}_29222.sh"
EXP2_SRC_URI="pillars_of_eternity_ii_deadfire_seeker_slayer_survivor_v${PV//./_}_29222.sh"
EXP3_SRC_URI="pillars_of_eternity_ii_deadfire_the_forgotten_sanctum_v${PV//./_}_29222.sh"

SRC_URI="
	${BASE_SRC_URI}
	dlc1? ( ${DLC1_SRC_URI} )
	dlc2? ( ${DLC2_SRC_URI} )
	dlc3? ( ${DLC3_SRC_URI} )
	dlc4? ( ${DLC4_SRC_URI} )
	dlc5? ( ${DLC5_SRC_URI} )
	dlc6? ( ${DLC6_SRC_URI} )
	dlc7? ( ${DLC7_SRC_URI} )
	exp1? ( ${EXP1_SRC_URI} )
	exp2? ( ${EXP2_SRC_URI} )
	exp3? ( ${EXP3_SRC_URI} )
	l10n_de? ( ${DE_SRC_URI} )
"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+dlc1 +dlc2 +dlc3 +dlc4 +dlc5 +dlc6 +dlc7 +exp1 +exp2 +exp3 l10n_de"
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
	x11-libs/pango
"
BDEPEND="
	app-arch/unzip
"

S="${WORKDIR}/data/noarch"

CHECKREQS_DISK_BUILD="50G"

pkg_nofetch() {
	einfo "Please buy & download \"${BASE_SRC_URI}\""
	use dlc1 && einfo "and \"${DLC1_SRC_URI}\""
	use dlc2 && einfo "and \"${DLC2_SRC_URI}\""
	use dlc3 && einfo "and \"${DLC3_SRC_URI}\""
	use dlc4 && einfo "and \"${DLC4_SRC_URI}\""
	use dlc5 && einfo "and \"${DLC5_SRC_URI}\""
	use dlc6 && einfo "and \"${DLC6_SRC_URI}\""
	use dlc7 && einfo "and \"${DLC7_SRC_URI}\""
	use exp1 && einfo "and \"${EXP1_SRC_URI}\""
	use exp2 && einfo "and \"${EXP2_SRC_URI}\""
	use exp3 && einfo "and \"${EXP3_SRC_URI}\""
	einfo "from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory."

	if use l10n_de; then
		einfo "Please also download \"${DE_SRC_URI}\" from:"
		einfo "  https://github.com/AurelioSilver/pillarsofeternity-2-german-patch/releases"
		einfo "and place it in your DISTDIR directory."
	fi
}

src_unpack() {
	unpack_zip "${DISTDIR}/${BASE_SRC_URI}"
	use dlc1 && unpack_zip "${DISTDIR}/${DLC1_SRC_URI}"
	use dlc2 && unpack_zip "${DISTDIR}/${DLC2_SRC_URI}"
	use dlc3 && unpack_zip "${DISTDIR}/${DLC3_SRC_URI}"
	use dlc4 && unpack_zip "${DISTDIR}/${DLC4_SRC_URI}"
	use dlc5 && unpack_zip "${DISTDIR}/${DLC5_SRC_URI}"
	use dlc6 && unpack_zip "${DISTDIR}/${DLC6_SRC_URI}"
	use dlc7 && unpack_zip "${DISTDIR}/${DLC7_SRC_URI}"
	use exp1 && unpack_zip "${DISTDIR}/${EXP1_SRC_URI}"
	use exp2 && unpack_zip "${DISTDIR}/${EXP2_SRC_URI}"
	use exp3 && unpack_zip "${DISTDIR}/${EXP3_SRC_URI}"

	if use l10n_de; then
		tar xvzf "${DISTDIR}/${DE_SRC_URI}" \
			--strip 1 \
			--exclude=README.md \
			--exclude=translation_helper \
			--exclude=.gitignore \
			-C "${S}/game/PillarsOfEternityII_Data" || die
	fi
}

src_install() {
	local dir="/opt/gog/${PN}"

	rm -r game/Docs \
		game/{Galaxy64,GalaxyCSharpGlue,GalaxyPeer64}.dll \
		game/PillarsOfEternityII_Data/Plugins/x86_64/libSDL2-2.0.so \
		game/PillarsOfEternityII_Data/Plugins/x86_64/libsteam_api.so || die

	dodir "${dir}"
	mv game/* "${D}/${dir}" || die

	# ensure sane permissions
	find "${D}/${dir}" -type f -exec chmod 0644 '{}' + || die
	find "${D}/${dir}" -type d -exec chmod 0755 '{}' + || die
	fperms +x "${dir}"/PillarsOfEternityII

	make_wrapper ${PN} "./PillarsOfEternityII" "${dir}"
	newicon -s 256 support/icon.png ${PN}.png
	make_desktop_entry ${PN} "Pillars Of Eternity II: Deadfire"
}
