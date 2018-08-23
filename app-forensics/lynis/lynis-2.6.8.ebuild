# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

DESCRIPTION="Security and system auditing tool"
HOMEPAGE="https://cisofy.com/lynis"
SRC_URI="https://cisofy.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="app-shells/bash:0"

DOCS=( CHANGELOG.md FAQ README )

S="${WORKDIR}/${PN}"

src_install() {
	dobashcomp extras/bash_completion.d/${PN}
	doman ${PN}.8
	einstalldocs

	exeinto /etc/cron.weekly
	newexe "${FILESDIR}"/${PN}.cron ${PN}

	dosbin ${PN}

	# stricter default perms, bug #507436
	diropts -m0700
	insopts -m0600

	insinto /usr/share/lynis
	doins -r db include plugins

	insinto /etc/lynis
	doins default.prf
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "A cron script has been installed to /etc/cron.weekly/${PN}."
		elog "To enable it, edit /etc/cron.weekly/${PN} and follow the"
		elog "directions."
		elog "If you want ${PN} to send mail, you will need to install"
		elog "virtual/mailx or alter the EMAIL_CMD variable in the"
		elog "cron script."
	fi
}
