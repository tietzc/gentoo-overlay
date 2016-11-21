# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2-utils python-single-r1

DESCRIPTION="Japanese input method Anthy IMEngine for IBus Framework"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://github.com/ibus/ibus-anthy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND="${PYTHON_DEPS}
	app-i18n/anthy
	app-i18n/ibus[introspection]
	nls? ( virtual/libintl )"

DEPEND="${RDEPEND}
	dev-libs/gobject-introspection
	dev-util/intltool
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
	>py-compile #397497
}

src_configure() {
	econf \
		--libexecdir=/usr/libexec \
		--enable-private-png \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
	find "${ED}" -name '*.la' -type f -delete || die
	python_optimize
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	optfeature "Anthy dictionary maintenance tool" app-dicts/kasumi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
