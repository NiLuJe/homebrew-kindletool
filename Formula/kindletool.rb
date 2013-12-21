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
    # FIXME: Doesn't find libarchive via pkg-config
    # FIXME: Doesn't appear to have CPPFLAGS, CFLAGS @ LDFLAGS set (:??)
    # FIXME: falls back to a dumb prefix, Homebrew doesn't actually link anything useful in /usr/local...
    system 'make'
    system 'make', 'install', "DESTDIR=#{prefix}"
  end
end
