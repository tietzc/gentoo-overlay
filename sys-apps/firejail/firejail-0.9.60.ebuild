# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Security sandbox for any type of processes"
HOMEPAGE="https://firejail.wordpress.com/"
SRC_URI="https://github.com/netblue30/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apparmor +chroot +file-transfer +network +seccomp +suid +userns x11"

RDEPEND="
	!sys-apps/firejail-lts
	apparmor? ( sys-libs/libapparmor )"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-no-manpages-compression.patch )

RESTRICT="mirror test"

src_prepare() {
	default

	find -name Makefile.in -exec sed -i -r \
		-e '/^\tinstall .*COPYING /d' \
		-e '/CFLAGS/s: (-O2|-ggdb) : :g' \
		-e '1iCC=@CC@' {} + || die
}

src_configure() {
	local myeconfargs=(
		--disable-contrib-install
		$(use_enable apparmor)
		$(use_enable chroot)
		$(use_enable file-transfer)
		$(use_enable network)
		$(use_enable seccomp)
		$(use_enable suid)
		$(use_enable userns)
		$(use_enable x11)
	)

	econf "${myeconfargs[@]}"
}
