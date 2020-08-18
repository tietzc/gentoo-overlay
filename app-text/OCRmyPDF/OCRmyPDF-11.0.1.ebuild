# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} )

inherit bash-completion-r1 distutils-r1 eutils

DESCRIPTION="Tool to add an OCR text layer to scanned PDF files, allowing them to be searched"
HOMEPAGE="https://github.com/jbarlow83/OCRmyPDF"
SRC_URI="https://github.com/jbarlow83/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-text/ghostscript-gpl
	>=app-text/pdfminer-six-20191110[${PYTHON_USEDEP}]
	>=app-text/tesseract-4.0.0
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/pikepdf-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.13.0[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	media-gfx/img2pdf[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-5.0.0[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.31[${PYTHON_USEDEP}]
		dev-python/python-xmp-toolkit[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

DOCS=( README.md docs/release_notes.rst )

python_prepare_all() {
	# remove hard dependency on pytest-runner
	sed -i -e "/pytest-runner/d" setup.py || die

	# strictly optional, hence add to optfeatures
	sed -i -e "/coloredlogs/d" setup.py || die

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
	optfeature "high-qualitiy loseless and lossy compression" media-libs/jbig2enc
}
