# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} )

MY_PN="OCRmyPDF"

inherit bash-completion-r1 distutils-r1 eutils

DESCRIPTION="Tool to add an OCR text layer to scanned PDF files, allowing them to be searched"
HOMEPAGE="https://github.com/jbarlow83/OCRmyPDF"
SRC_URI="https://github.com/jbarlow83/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-text/ghostscript-gpl
	app-text/pdfminer-six[${PYTHON_USEDEP}]
	app-text/tesseract
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pikepdf[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	media-gfx/img2pdf[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
"

DOCS=( README.md docs/release_notes.rst )

S="${WORKDIR}/${MY_PN}-${PV}"

python_prepare_all() {
	# remove hard dependency on pytest-runner
	sed -i -e "/pytest-runner/d" setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp misc/completion/${PN}.bash ${PN}
}

pkg_postinst() {
	optfeature "scan post-processing" app-text/unpaper
	optfeature "lossy quantization and compression" media-gfx/pngquant
	optfeature "high-qualitiy loseless and lossy compression" media-libs/jbig2enc
}