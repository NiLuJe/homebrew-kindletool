class Kindletool < Formula
  homepage "https://github.com/NiLuJe/KindleTool"
  url "https://github.com/NiLuJe/KindleTool/archive/v1.6.4.tar.gz"
  sha256 "1876e13f33fe1026c51632ce3602ef8a011738af9ed7ed933fd18767f967da21"

  head "https://github.com/NiLuJe/KindleTool.git", :shallow => false

  depends_on "pkg-config" => :build
  # FIXME: Call me when homebrew stops getting its panties in a bunch...
  # If we uncomment this perfectly fine and proper dep, we end up with a
  # (very helpful...) 'Error: Operation already in progress for nettle'...
  # Bets guess: homebrew doesn't like the fact that libarchive already depends
  # on nettle through a :recommended...
  # Current workaround: just comment the dep, and hope users follow the README,
  # because the workaround of depending on libarchive --with-nettle is ugly and wrong,
  # and also annoying, because we have to create a bogus with-nettle option in libarchive
  # to satisfy this conditional, since :recommended only create a without-* option...
  # Leave this in, commented, so that brew audit complains about it if I ever forget about it...
  #depends_on "NiLuJe/kindletool/nettle"
  depends_on "NiLuJe/kindletool/libarchive"

  def install
    # NOTE: Leave my damn warnings alone! (noop with superenv)
    ENV.enable_warnings

    # Make sure the buildsystem will be able to generate a proper version tag
    ENV["GIT_DIR"] = cached_download/".git" if build.head?

    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=/."
  end
end
