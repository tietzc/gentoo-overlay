# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="find cruft files not managed by portage"
HOMEPAGE="https://github.com/vaeth/find_cruft"
SRC_URI="https://github.com/vaeth/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-lang/perl"

src_prepare() {
	default
	use prefix || sed -i \
		-e '1s"^#!/usr/bin/env perl$"#!'"${EPREFIX}/usr/bin/perl"'"' \
		-- bin/* || die
}

src_install() {
	dobin bin/*

	insinto /etc
	doins -r etc/*

	insinto /usr/share/zsh/site-functions
	doins zsh/_*

	einstalldocs
}

pkg_postinst() {
	optfeature "faster execution" app-portage/eix
}
