require 'formula'

class Libarchive < Formula
  homepage 'http://www.libarchive.org'
  url 'http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz'
  sha1 '6a991777ecb0f890be931cec4aec856d1a195489'

  head 'https://github.com/libarchive/libarchive.git'

  keg_only :provided_by_osx

  option 'with-nettle', 'Build with nettle support'
  
  head do
    depends_on :autoconf => :build
    depends_on :automake => :build
    depends_on :libtool => :build
  end
  depends_on 'xz' => :recommended
  depends_on 'lzo' => :recommended
  depends_on 'NiLuJe/kindletool/nettle' => :recommended
  depends_on 'expat' => :recommended
  depends_on :libxml2 if build.without? 'expat'

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
    args << '--without-nettle'  if build.without? 'nettle'
    args << '--without-lzma'    if build.without? 'xz'
    args << '--without-lzo2'    if build.without? 'lzo'
    args << '--without-expat'   if build.without? 'expat'
    args << '--without-xml2'    if build.with? 'expat'

    system './configure', *args
    system 'make'
    system 'make', 'install'
  end
end
