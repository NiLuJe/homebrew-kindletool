require 'formula'

class Kindletool < Formula
  homepage 'https://github.com/NiLuJe/KindleTool'
  url 'https://github.com/NiLuJe/KindleTool/archive/v1.6.2.tar.gz'
  sha1 'f594bcfb1b6d63d8396db1d286766925dccff4ea'

  head 'https://github.com/NiLuJe/KindleTool.git', :shallow => false

  depends_on 'pkg-config' => :build
  # FIXME: Recent brew checkouts barf on this.
  # Best guess: because besides our hard-depend on nettle,
  # libarchive also depends on nettle by default through a :recommended
  # Work around this by removing the hard-dep on nettle, and instead
  # depending on libarchive w/ nettle.
  # While technically wrong from KindleTool's point of view,
  # (we do need nettle for ourselves, and not libarchive's nettle support),
  # from brew's point of view, it achieves the same thing: ensuring we actually
  # pull both libarchive & nettle as a dep.
  #depends_on 'NiLuJe/kindletool/nettle'
  depends_on 'NiLuJe/kindletool/libarchive' => 'with-nettle'

  def install
    # NOTE: Leave my damn warnings alone! (noop with superenv)
    ENV.enable_warnings

    # Make sure the buildsystem will be able to generate a proper version tag
    ENV['GIT_DIR'] = cached_download/'.git' if build.head?

    system 'make'
    system 'make', 'install', "DESTDIR=#{prefix}", 'PREFIX=/.'
  end
end
