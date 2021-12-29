# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit bash-completion-r1 distutils-r1 optfeature

DESCRIPTION="Tool to add an OCR text layer to scanned PDF files, allowing them to be searched"
HOMEPAGE="https://github.com/jbarlow83/OCRmyPDF"
SRC_URI="https://github.com/jbarlow83/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-text/ghostscript-gpl
	>=app-text/pdfminer-six-20191110[${PYTHON_USEDEP}]
	>=app-text/tesseract-4.0.0
	>=dev-python/pikepdf-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-8.2.0[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/reportlab-3.5.66[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	media-gfx/img2pdf[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/python-xmp-toolkit[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs dev-python/sphinx-issues dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_prepare_all() {
	# strictly optional, hence add to optfeatures
	sed -i -e "/coloredlogs/d" setup.cfg || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp misc/completion/ocrmypdf.bash ocrmypdf
}

pkg_postinst() {
	optfeature "scan post-processing" app-text/unpaper
	optfeature "colored output" dev-python/coloredlogs
	optfeature "lossy quantization and compression" media-gfx/pngquant
	optfeature "high-quality lossless and lossy compression" media-libs/jbig2enc
}
