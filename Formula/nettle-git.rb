class NettleGit < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.7.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.7.2.tar.gz"
  sha256 "8d2a604ef1cde4cd5fb77e422531ea25ad064679ff0adf956e78b3352e0ef162"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  head "https://git.lysator.liu.se/nettle/nettle.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "aa390782861378db29a3d19d8be98c291bedc32535c3dd35bc5e1ba91c35a170"
    sha256 cellar: :any, big_sur:       "bbcea7ed54f806373b9689ee05379f509007c58aa737892a6bd77ccb0ee05f67"
    sha256 cellar: :any, catalina:      "08a2b9568b211c2c8dbf2fb4d1acbb5ace419594f75bf76733b687c441b13a47"
    sha256 cellar: :any, mojave:        "0dc3ca8dc38af69eee4afa0fd31f93970c23007e319a98cb2036b3cbb0b17cec"
  end

  keg_only "available in core"

  depends_on "autoconf" => :build

  depends_on "gmp"

  uses_from_macos "m4" => :build

  def install
    # The LLVM shipped with Xcode/CLT 10+ compiles binaries/libraries with
    # ___chkstk_darwin, which upsets nettle's expected symbol check.
    # https://github.com/Homebrew/homebrew-core/issues/28817#issuecomment-396762855
    # https://lists.lysator.liu.se/pipermail/nettle-bugs/2018/007300.html
    if DevelopmentTools.clang_build_version >= 1000
      inreplace "testsuite/symbols-test", "get_pc_thunk",
                                          "get_pc_thunk|(_*chkstk_darwin)"
    end

    system "./.bootstrap" if build.head?

    # Set a bunch of defaults
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--enable-shared",
    ]

    args << "--build=aarch64-apple-darwin#{OS.kernel_version}" if Hardware::CPU.arm?
    
    # We need a TeX env to build docs from scratch...
    args << "--disable-documentation" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "check"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nettle/sha1.h>
      #include <stdio.h>

      int main()
      {
        struct sha1_ctx ctx;
        uint8_t digest[SHA1_DIGEST_SIZE];
        unsigned i;

        sha1_init(&ctx);
        sha1_update(&ctx, 4, "test");
        sha1_digest(&ctx, SHA1_DIGEST_SIZE, digest);

        printf("SHA1(test)=");

        for (i = 0; i<SHA1_DIGEST_SIZE; i++)
          printf("%02x", digest[i]);

        printf("\\n");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnettle", "-o", "test"
    system "./test"
  end
end
