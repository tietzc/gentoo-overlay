# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Rip your PGS subtitles"
HOMEPAGE="https://github.com/ratoaq2/pgsrip"
SRC_URI="https://github.com/ratoaq2/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-text/tesseract
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/babelfish[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pysrt[${PYTHON_USEDEP}]
	dev-python/pytesseract[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/trakit[${PYTHON_USEDEP}]
	media-libs/opencv[python,${PYTHON_USEDEP}]
	media-video/cleanit[${PYTHON_USEDEP}]
	media-video/mkvtoolnix
"
