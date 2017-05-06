# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

COMMIT="693129fa0dca62c0a6f43403dec3dfc4171b5295"
THUNDERBIRD_VERSION="$(get_major_version)"

DESCRIPTION="CardDAV plugin for mail-client/thunderbird"
HOMEPAGE="http://www.sogo.nu/downloads/frontends.html"
SRC_URI="https://github.com/inverse-inc/${PN}.tb${THUNDERBIRD_VERSION}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="mail-client/thunderbird[lightning]"

DEPEND="${RDEPEND}
	app-arch/unzip"

PATCHES=( "${FILESDIR}/makefile.patch" )

S="${WORKDIR}/${PN}.tb${THUNDERBIRD_VERSION}-${COMMIT}"

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/thunderbird"

	emid=$(sed -n '/em:id=/!d; s/\s*em:id="//; s/"\s*//; p; q' install.rdf)

	dodir ${MOZILLA_FIVE_HOME}/extensions/${emid}
	cd "${ED}"${MOZILLA_FIVE_HOME}/extensions/${emid} || die
	unzip -qo "${S}/${PN}-$(get_version_component_range 1-3).xpi" || die
}
