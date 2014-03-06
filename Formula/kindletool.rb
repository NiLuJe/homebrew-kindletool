require 'formula'

class Kindletool < Formula
  homepage 'https://github.com/NiLuJe/KindleTool'
  url 'https://github.com/NiLuJe/KindleTool/archive/v1.6.2.tar.gz'
  sha1 'f594bcfb1b6d63d8396db1d286766925dccff4ea'

  head 'https://github.com/NiLuJe/KindleTool.git', :shallow => false

  depends_on 'pkg-config' => :build
  depends_on 'NiLuJe/kindletool/nettle'
  depends_on 'NiLuJe/kindletool/libarchive'

  def install
    # NOTE: Leave my damn warnings alone! (noop with superenv)
    ENV.enable_warnings

    # Make sure the buildsystem will be able to generate a proper version tag
    ENV['GIT_DIR'] = cached_download/'.git' if build.head?

    system 'make'
    system 'make', 'install', "DESTDIR=#{prefix}", 'PREFIX=/.'
  end
end
