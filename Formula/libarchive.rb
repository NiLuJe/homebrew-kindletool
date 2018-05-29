class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "http://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.3.2.tar.gz"
  sha256 "ed2dbd6954792b2c054ccf8ec4b330a54b85904a80cef477a1c74643ddafa0ce"

  head "https://github.com/libarchive/libarchive.git"

  bottle do
    cellar :any
    sha256 "ee8c56199da11b8e6ac30e577792288d729233dda36100dbd16192af656bff5d" => :high_sierra
    sha256 "3afbbb3c4c12dcac7f55d7a038249e4553c4b13bb5c6a5251db1099277446490" => :sierra
    sha256 "0805b457512f14129a12148c7ad4fc5880c7594515781bc2a11e3a5431c220ec" => :el_capitan
    sha256 "8ef52679c4f98f7aa7ce0ecdb854d3fea70b46192011e447fabdde8aec5cd940" => :yosemite
  end

  keg_only :provided_by_macos

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "xz" => :recommended
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
          "--without-openssl",
          "--without-lzmadec"
          ]

    # And then, handle our conditionals...
    args << "--without-nettle"  if build.without? "nettle"
    args << "--without-lzma"    if build.without? "xz"
    args << "--without-lzo2"    if build.without? "lzo"
    args << "--without-expat"   if build.without? "expat"
    args << "--without-xml2"    if build.with? "expat"

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
