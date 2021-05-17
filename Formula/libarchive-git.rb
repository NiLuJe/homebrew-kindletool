class LibarchiveGit < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.4.1.tar.xz"
  sha256 "bb84e02f08cc3027e08e2473fc46eb7724ba9244e9c6ef8d122f68addd6042f7"

  head "https://github.com/libarchive/libarchive.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, catalina:    "65c37e048db20445439e1615ac94d050e8d6a49a95afbe32a07128e095a5939d"
    sha256 cellar: :any, mojave:      "38215a372c5936c41fea411fb491db067b67564da37dc5c370f259e5da8c8c62"
    sha256 cellar: :any, high_sierra: "5896f4cf854c58b0ef44b5820e3e406133e762dce90f72afd9d045d88e898734"
  end

  keg_only :provided_by_macos

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "xz"

  def install
    system "./build/autogen.sh" if build.head?
    system "./configure",
           "--prefix=#{prefix}",
           "--without-lzo2",    # Use lzop binary instead of lzo2 due to GPL
           "--without-nettle",  # xar hashing option but GPLv3
           "--without-xml2",    # xar hashing option but tricky dependencies
           "--without-openssl", # mtree hashing now possible without OpenSSL
           "--with-expat"       # best xar hashing option

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
    assert_match(/test/, shell_output("#{bin}/bsdtar -xOzf test.tar.gz"))
  end
end
