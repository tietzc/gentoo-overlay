# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils

FULL_P=UrbanTerror431_full

DESCRIPTION="Hollywood tactical shooter based on the ioquake3 engine"
HOMEPAGE="http://www.urbanterror.info"
SRC_URI="
	http://1.mirror.eu.urtnet.info/urt/43/releases/zips/${FULL_P}.zip
	https://github.com/Barbatos/ioq3-for-UrbanTerror-4/archive/release-${PV}.tar.gz -> ${P}.tar.gz
	https://upload.wikimedia.org/wikipedia/commons/5/56/Urbanterror.svg -> ${PN}.svg"

LICENSE="GPL-2 Q3AEULA-20000111 urbanterror-4.2-maps"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+altgamma"
RESTRICT="mirror"

RDEPEND="
	media-libs/libsdl[X,opengl,pulseaudio,sound,video]
	media-libs/libvorbis
	net-misc/curl"

DEPEND="${RDEPEND}
	app-arch/unzip"

PATCHES=( "${FILESDIR}"/${PN}-4.3-build.patch )

S=${WORKDIR}/ioq3-for-UrbanTerror-4-release-${PV}
S_DATA=${WORKDIR}/UrbanTerror43

src_compile() {
	emake \
		ARCH=$(usex amd64 "x86_64" "i386") \
		PLATFORM=linux \
		DEFAULT_BASEDIR=/usr/share/${PN} \
		BUILD_CLIENT=1 \
		BUILD_CLIENT_SMP=0 \
		BUILD_SERVER=0 \
		USE_SDL=1 \
		USE_OPENAL=0 \
		USE_OPENAL_DLOPEN=0 \
		USE_CODEC_VORBIS=1 \
		USE_ALTGAMMA=$(usex altgamma 1 0) \
		USE_LOCAL_HEADERS=0 \
		Q="" \
		release
}

src_install() {
	local my_arch=$(usex amd64 "x86_64" "i386")

	dodoc ChangeLog README md4-readme.txt
	dodoc "${S_DATA}"/q3ut4/readme43.txt
	insinto /usr/share/${PN}/q3ut4
	doins "${S_DATA}"/q3ut4/*.pk3

	newbin build/release-linux-${my_arch}/Quake3-UrT.${my_arch} ${PN}
	doicon -s scalable "${DISTDIR}"/${PN}.svg
	make_desktop_entry ${PN} "UrbanTerror"
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
