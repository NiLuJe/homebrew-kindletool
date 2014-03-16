require 'formula'

class Kindletool < Formula
  homepage 'https://github.com/NiLuJe/KindleTool'
  url 'https://github.com/NiLuJe/KindleTool/archive/v1.6.2.tar.gz'
  sha1 'f594bcfb1b6d63d8396db1d286766925dccff4ea'

  head 'https://github.com/NiLuJe/KindleTool.git', :shallow => false

  depends_on 'pkg-config' => :build
  depends_on 'NiLuJe/kindletool/libarchive'
  # FIXME: Call me when homebrew stops getting its panties in a bunch...
  # If we uncomment this perfectly fine and proper dep, we end up with a
  # (very helpful...) 'Error: Operation already in progress for nettle'...
  # Bets guess: homebrew doesn't like the fact that libarchive already depends
  # on nettle through a :recommended...
  # Current workaround: just comment the dep, and hope users follow the README,
  # because the workaround of depending on libarchive --with-nettle is ugly and wrong,
  # and also annoying, because we have to create a bogus with-nettle option in libarchive
  # to satisfy this conditional, since :recommended only create a without-* option...
  # Levae this in, commented, so that brew audit complains about it if I ever forget about it...
  #depends_on 'NiLuJe/kindletool/nettle'

  def install
    # NOTE: Leave my damn warnings alone! (noop with superenv)
    ENV.enable_warnings

    # Make sure the buildsystem will be able to generate a proper version tag
    ENV['GIT_DIR'] = cached_download/'.git' if build.head?

    system 'make'
    system 'make', 'install', "DESTDIR=#{prefix}", 'PREFIX=/.'
  end
end
