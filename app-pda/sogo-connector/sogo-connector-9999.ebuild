# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils git-r3

DESCRIPTION="CardDAV plugin for mail-client/thunderbird"
HOMEPAGE="http://www.sogo.nu/downloads/frontends.html"
EGIT_REPO_URI="https://github.com/inverse-inc/sogo-connector.tb31.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="|| ( =mail-client/thunderbird-38*[lightning] =mail-client/thunderbird-45*[lightning] )"

DEPEND="${RDEPEND}"

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/thunderbird"

	emid=$(sed -n '/em:id=/!d; s/\s*em:id="//; s/"\s*//; p; q' install.rdf)

	dodir ${MOZILLA_FIVE_HOME}/extensions/${emid} || die
	cd "${ED}"${MOZILLA_FIVE_HOME}/extensions/${emid} || die
	unzip -o "${S}/${PN}-*.xpi" || die
}
