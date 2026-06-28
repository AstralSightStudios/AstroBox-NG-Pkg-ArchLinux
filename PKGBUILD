# Maintainer: WaiJade <waijade@outlook.com>

pkgname=astrobox-ng
pkgver=2.0.0
pkgrel=1
pkgdesc="AstroBox is a leading tool for managing and extending wearable devices"
arch=('x86_64')
url="https://github.com/AstralSightStudios/AstroBox-NG"
license=('AGPL-3.0')
depends=(
    'webkit2gtk-4.1'
    'gtk3'
    'libx11'
    'gcc-libs'
    'glibc'
    'zlib'
    'bzip2'
    'libxcb'
    'libxkbcommon'
    'dbus'
    'libsecret'
    'libsoup3'
    'gstreamer'
    'gst-plugins-base'
    'libepoxy'
    'atk'
    'at-spi2-core'
    'cairo'
    'pango'
    'gdk-pixbuf2'
    'harfbuzz'
    'hicolor-icon-theme'
    'desktop-file-utils'
    'shared-mime-info'
)
source=("${url}/releases/download/${pkgver}/AstroBox_${pkgver}_x86_64.pkg.tar.zst")
sha256sums=('52d05bb32d0cd27e01e06e26a4d90434407f90f3237d8bb728f585d3733fab63')

package() {
    cd "$srcdir"
    cp -a . "$pkgdir"
}
