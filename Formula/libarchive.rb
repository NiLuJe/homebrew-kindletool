class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.3.3.tar.gz"
  sha256 "ba7eb1781c9fbbae178c4c6bad1c6eb08edab9a1496c64833d1715d022b30e2e"

  head "https://github.com/libarchive/libarchive.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0a789c0f212b5e1d06acc213bda685bf97e3036f89d8f4d2580b29bac32b3d3d" => :mojave
    sha256 "078eed374d5df2b561c6d36fe7284946f0556ba450e86fb048ca443cd4e3d894" => :high_sierra
    sha256 "fc7b2124e4d4bdb8df5e41e9b5992d151e7505e71e790f9e53ac8a7cdd55490d" => :sierra
  end

  keg_only :provided_by_macos

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "xz"
  depends_on "lz4" => :optional
  depends_on "lzo" => :recommended
  depends_on "NiLuJe/kindletool/nettle" => :recommended
  depends_on "expat" => :recommended
  depends_on :libxml2 if build.without? "expat"

  def install
    # We need to autoreconf for git checkouts
    system "./build/autogen.sh" if build.head?

    # Set a bunch of defaults
    args = [
          "--prefix=#{prefix}",
          "--enable-shared",
          "--with-zlib",
          "--with-bz2lib",
          "--with-iconv",
          "--without-openssl" # mtree hashing now possible without OpenSSL
          ]

    # And then, handle our conditionals...
    args << "--without-nettle"  if build.without? "nettle" # xar hashing option but GPLv3
    args << "--without-lzo2"    if build.without? "lzo"    # Use lzop binary instead of lzo2 due to GPL
    args << "--without-expat"   if build.without? "expat"  # best xar hashing option
    args << "--without-xml2"    if build.with? "expat"     # xar hashing option but tricky dependencies

    system "./configure", *args
    system "make", "install"

    # Just as apple does it.
    ln_s bin/"bsdtar", bin/"tar"
    ln_s bin/"bsdcpio", bin/"cpio"
    ln_s man1/"bsdtar.1", man1/"tar.1"
    ln_s man1/"bsdcpio.1", man1/"cpio.1"
  end

  test do
    (testpath/"test").write("test")
    system bin/"bsdtar", "-czvf", "test.tar.gz", "test"
    assert_match /test/, shell_output("#{bin}/bsdtar -xOzf test.tar.gz")
  end
end
