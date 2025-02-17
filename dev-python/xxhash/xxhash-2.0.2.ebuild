# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python binding for the xxHash library"
HOMEPAGE="https://github.com/ifduyue/python-xxhash
	https://pypi.org/project/xxhash/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND=">=dev-libs/xxhash-0.8.0"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest

python_configure_all() {
	export XXHASH_LINK_SO=1
}

python_test() {
	cd tests || die
	eunittest
}
