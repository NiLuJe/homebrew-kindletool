require 'formula'

class Libarchive < Formula
  homepage 'http://www.libarchive.org'
  url 'http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz'
  sha1 '6a991777ecb0f890be931cec4aec856d1a195489'

  head 'https://github.com/libarchive/libarchive.git'

  keg_only :provided_by_osx

  depends_on 'xz' => :recommended
  depends_on 'lzo' => :recommended
  depends_on 'NiLuJe/kindletool/nettle' => :recommended
  depends_on 'expat' => :recommended
  depends_on :libxml2 if build.without? 'expat'

  def patches
    # Fix issue 317
    "https://github.com/NiLuJe/KindleTool/raw/master/tools/libarchive-fix-issue-317.patch" unless build.head?
    # Fix issue 317, the build with autotools, and generate a pkg-config file when usig CMake.
    "https://github.com/NiLuJe/KindleTool/raw/master/tools/libarchive-patch-bundle.patch" if build.head?
  end

  def install
    # We need to autoreconf for git checkouts
    system './build/autogen.sh' if build.head?

    # Set a bunch of defaults
    args = [
          "--prefix=#{prefix}",
          '--enable-shared',
          '--with-zlib',
          '--with-bz2lib',
          '--with-iconv',
          '--without-openssl',
          '--without-lzmadec'
          ]

    # And then, handle our conditionals...
    args << '--without-nettle'  unless build.with? 'nettle'
    args << '--without-lzma'    unless build.with? 'xz'
    args << '--without-lzo2'    unless build.with? 'lzo'
    args << '--without-expat'   unless build.with? 'expat'
    args << '--without-xml2'    if build.with? 'expat'

    system './configure', *args
    system 'make'
    system 'make', 'install'
  end
end
