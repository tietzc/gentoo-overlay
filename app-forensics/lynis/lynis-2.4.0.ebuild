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

RDEPEND="
	app-shells/bash:*
	cron? (
		virtual/cron
		virtual/mailx
	)"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	doman ${PN}.8
	dodoc CHANGELOG.md FAQ README

	dobashcomp extras/bash_completion.d/${PN}

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
		newexe "${FILESDIR}/${PN}.cron" ${PN}
	fi
}

pkg_postinst() {
	if use cron ; then
		elog "A cron script has been installed to /etc/cron.weekly/lynis."
		elog "To enable it, edit /etc/cron.weekly/lynis and follow the"
		elog "directions."
	fi
}
