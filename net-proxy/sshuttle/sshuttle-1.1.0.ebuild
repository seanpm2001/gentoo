# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 linux-info

DESCRIPTION="Transparent proxy server that works as a poor man's VPN using ssh"
HOMEPAGE="https://github.com/sshuttle/sshuttle https://pypi.org/project/sshuttle/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/sphinx
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	dev-python/psutil[${PYTHON_USEDEP}]
	|| ( net-firewall/iptables net-firewall/nftables )
"

CONFIG_CHECK="~NETFILTER_XT_TARGET_HL ~IP_NF_TARGET_REDIRECT ~IP_NF_MATCH_TTL ~NF_NAT"

distutils_enable_tests pytest

python_prepare_all() {
	# Don't run tests via setup.py pytest
	sed -i "/setup_requires=/s/'pytest-runner'//" setup.py || die

	# Don't require pytest-cov when running tests
	sed -i "s/^addopts =/#\0/" setup.cfg || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	emake -j1 -C docs html man
}

python_install_all() {
	HTML_DOCS=( docs/_build/html/. )

	doman docs/_build/man/*

	distutils-r1_python_install_all
}
