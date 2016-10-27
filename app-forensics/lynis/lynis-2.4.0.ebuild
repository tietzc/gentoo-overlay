# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit bash-completion-r1 eutils

DESCRIPTION="Security and system auditing tool"
HOMEPAGE="https://cisofy.com/lynis"
SRC_URI="https://cisofy.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cron"
RESTRICT="mirror"

RDEPEND="app-shells/bash:*"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	doman lynis.8
	dodoc CHANGELOG.md FAQ README

	dobashcomp extras/bash_completion.d/lynis

	# stricter default perms, bug #507436
	diropts -m0700
	insopts -m0600

	insinto /usr/share/${PN}
	doins -r db include plugins

	dosbin ${PN}

	insinto /etc/${PN}
	doins default.prf

	if use cron ; then
		exeinto /etc/cron.weekly
		newexe "${FILESDIR}"/${PN}.cron lynis
	fi
}

pkg_postinst() {
	use cron && einfo "A cron script has been installed to /etc/cron.weekly/lynis."
}
