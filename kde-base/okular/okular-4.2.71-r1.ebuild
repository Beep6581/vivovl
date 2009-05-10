# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KMNAME="kdegraphics"
inherit kde4-meta

DESCRIPTION="Okular is an universal document viewer based on KPDF for KDE 4."
KEYWORDS="~amd64 ~x86"
IUSE="chm crypt debug djvu doc ebook +jpeg +ps +pdf +tiff"

DEPEND="
	media-libs/freetype
	chm? ( dev-libs/chmlib )
	crypt? ( app-crypt/qca:2 )
	djvu? ( app-text/djvu )
	ebook? ( app-text/ebook-tools )
	jpeg? ( media-libs/jpeg )
	pdf? ( >=virtual/poppler-qt4-0.8.5 )
	ps? ( app-text/libspectre )
	tiff? ( media-libs/tiff )
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="libs/mobipocket"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with chm CHM)
		$(cmake-utils_use_with crypt QCA2)
		$(cmake-utils_use_with djvu DjVuLibre)
		$(cmake-utils_use_with ebook EPub)
		$(cmake-utils_use_with jpeg JPEG)
		$(cmake-utils_use_with ps LibSpectre)
		$(cmake-utils_use_with pdf PopplerQt4)
		$(cmake-utils_use_with pdf Poppler)
		$(cmake-utils_use_with tiff TIFF)"

	kde4-meta_src_configure

	# we have problem with landscape pdf and hp printers
	sed -e 's:landscape:portrait:g' -i okular/core/fileprinter.cpp \
	|| die "failed sed 1 "
	# https://bugs.kde.org/show_bug.cgi?id=191859
	# permit view of big documents
	sed -e 's:setMaxLength( 4 );::' -i okular/ui/minibar.cpp \
	|| die "failed sed 2"
}
