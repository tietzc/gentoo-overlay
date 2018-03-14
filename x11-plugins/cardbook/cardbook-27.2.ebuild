# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="CardBook"

DESCRIPTION="A new Thunderbird address book based on the CardDAV and vCard standards"
HOMEPAGE="https://addons.mozilla.org/thunderbird/addon/cardbook"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="mail-client/thunderbird[lightning]"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	local emid

	emid="$(sed -n '/\<\(em:\)*id\>/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q' install.rdf)" \
		|| die "Failed to determine extension id"

	insinto "/usr/$(get_libdir)/thunderbird/extensions/${emid}"
	doins -r chrome components modules chrome.manifest install.rdf

	einstalldocs
}
