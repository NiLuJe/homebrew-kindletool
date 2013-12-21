require 'formula'

class Kindletool < Formula
  homepage 'https://github.com/NiLuJe/KindleTool'
  url 'https://github.com/NiLuJe/KindleTool/archive/v1.5.9.tar.gz'
  sha1 'aa8167c0e239456ab3690d6ad98804908f92f1f8'

  head 'https://github.com/NiLuJe/KindleTool.git'

  depends_on 'pkg-config' => :build
  depends_on 'NiLuJe/kindletool/libarchive'
  depends_on 'NiLuJe/kindletool/nettle'

  def install
    # Superenv kills *FLAGS from the env, which confuses our Makefile...
    ENV['CFLAGS'] = '-O2 ${HOMEBREW_OPTFLAGS}'
    # Those need to be set for our Makefile's logic.
    ENV['CPPFLAGS'] = ' '
    ENV['LDFLAGS'] = ' '

    system 'make'
    system 'make', 'install', "DESTDIR=#{prefix}", 'PREFIX=/.'
  end
end
