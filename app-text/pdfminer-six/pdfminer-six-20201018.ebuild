# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Community maintained fork of pdfminer"
HOMEPAGE="https://github.com/pdfminer/pdfminer.six"
SRC_URI="https://github.com/pdfminer/pdfminer.six/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
"

distutils_enable_tests nose

S="${WORKDIR}/${PN//-/.}-${PV}"
