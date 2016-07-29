# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils versionator

THUNDERBIRD_VERSION="$(get_major_version)"

DESCRIPTION="CardDAV plugin for mail-client/thunderbird"
HOMEPAGE="http://www.sogo.nu/downloads/frontends.html"
# SRC_URI="https://github.com/inverse-inc/${PN}.tb${THUNDERBIRD_VERSION}/archive/${P}.tar.gz"

# Use git-r3.eclass since upstream appears to be no longer doing actual releases for newer versions on GitHub anymore.
inherit git-r3
EGIT_REPO_URI="https://github.com/inverse-inc/sogo-connector.tb31.git"
EGIT_COMMIT="2253f36fb2093db6749127ddd48270f70675ed72"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( =mail-client/thunderbird-38*[lightning] =mail-client/thunderbird-45*[lightning] )"

DEPEND="${RDEPEND}"

# S="${WORKDIR}/${PN}.tb${THUNDERBIRD_VERSION}-${P}"

src_prepare() {
	eapply "${FILESDIR}/makefile.patch"
	default
}

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/thunderbird"

	emid=$(sed -n '/em:id=/!d; s/\s*em:id="//; s/"\s*//; p; q' install.rdf)

	dodir ${MOZILLA_FIVE_HOME}/extensions/${emid} || die
	cd "${ED}"${MOZILLA_FIVE_HOME}/extensions/${emid} || die
	unzip "${S}/${P}.xpi" || die
}
