# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Commandline tool for popular vector formats convertion"
HOMEPAGE="http://sk1project.org/modules.php?name=Products&product=uniconvertor https://code.google.com/p/uniconvertor/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

KEYWORDS="amd64 ~arm hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~x86-solaris"
SLOT="0"
LICENSE="GPL-2 LGPL-2"
IUSE=""

RDEPEND="
	dev-python/pycairo[${PYTHON_USEDEP}]
	media-gfx/imagemagick:=
	media-libs/lcms:2
	dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/ghostscript-gpl"

PATCHES=(
	"${FILESDIR}"/${P}-import.patch
	"${FILESDIR}"/${P}-libimg.patch
	"${FILESDIR}"/${P}-test.patch
	)

python_prepare_all() {
	local wand wandI
	wand=$(pkg-config --libs MagickWand | sed -e "s:^ *::g" -e "s: *$::g" -e "s:-l:\':g" -e "s: :',:g" -e "s:$:':g" -e "s:,'$::g")
	wandI=$(pkg-config --cflags-only-I MagickWand)
	wandI="${wandI//-I\/usr\/include\/}"

	distutils-r1_python_prepare_all

	sed \
		-e "/libraries/s:'MagickWand':${wand}:g" \
		-e "/include_dirs/s:ImageMagick-6:${wandI}:g"\
		-i setup.py || die

	ln -sf \
		"${EPREFIX}"/usr/share/imagemagick/sRGB.icm \
		src/unittests/cms_tests/cms_data/sRGB.icm || die
}

python_test() {
	einfo ${PYTHONPATH}
	#distutils_install_for_testing
	cd src/unittests || die
	${EPYTHON} all_tests.py || die
}
