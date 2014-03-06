require 'formula'

class Kindletool < Formula
  homepage 'https://github.com/NiLuJe/KindleTool'
  url 'https://github.com/NiLuJe/KindleTool/archive/v1.6.1.tar.gz'
  sha1 '7190c7608b2bf123b976c59b2e99c7e4e033232c'

  head 'https://github.com/NiLuJe/KindleTool.git'

  depends_on 'pkg-config' => :build
  depends_on 'NiLuJe/kindletool/libarchive'
  depends_on 'NiLuJe/kindletool/nettle'

  def install
    # NOTE: Leave my damn warnings alone! (noop with superenv)
    ENV.enable_warnings
    
    # Make sure the buildsystem will be able to generate a proper version tag
    ENV['GIT_DIR'] = cached_download/'.git'

    system 'make'
    system 'make', 'install', "DESTDIR=#{prefix}", 'PREFIX=/.'
  end
end
