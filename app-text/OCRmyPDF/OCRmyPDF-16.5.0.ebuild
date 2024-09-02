# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit bash-completion-r1 distutils-r1 optfeature

DESCRIPTION="Tool to add an OCR text layer to scanned PDF files, allowing them to be searched"
HOMEPAGE="https://github.com/ocrmypdf/OCRmyPDF"
SRC_URI="https://github.com/ocrmypdf/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-text/ghostscript-gpl
	>=app-text/pdfminer-20220506[${PYTHON_USEDEP}]
	>=app-text/tesseract-4.1.1
	>=dev-python/deprecation-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	>=dev-python/pikepdf-8.10.1[${PYTHON_USEDEP}]
	>=dev-python/pillow-10.0.1[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.0.0[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	>=media-gfx/img2pdf-0.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		app-text/unpaper
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/python-xmp-toolkit[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
		media-gfx/pngquant
	)
"

distutils_enable_sphinx docs dev-python/sphinx-issues dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp misc/completion/ocrmypdf.bash ocrmypdf
}

pkg_postinst() {
	optfeature "scan post-processing" app-text/unpaper
	optfeature "lossy quantization and compression" media-gfx/pngquant
	optfeature "high-quality lossless and lossy compression" media-libs/jbig2enc
}
