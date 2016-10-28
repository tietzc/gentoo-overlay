# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils xdg-utils

DESCRIPTION="Securely and easily download, verify, install, and launch Tor Browser in Linux"
HOMEPAGE="https://github.com/micahflee/torbrowser-launcher"
SRC_URI="https://github.com/micahflee/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="${PYTHON_DEPS}
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-14.0.1[${PYTHON_USEDEP},crypt]
	>=dev-python/twisted-web-14.0.1[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
	app-crypt/gnupg
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyliblzma[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all

	# delete apparmor profiles
	rm -r "${D}/etc/apparmor.d" || die "Failed to remove apparmor profiles"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update

	optfeature "updating over system TOR" "net-misc/tor dev-python/txsocksx"
	optfeature "modem sound support" "dev-python/pygame"
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
