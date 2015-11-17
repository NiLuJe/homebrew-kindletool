require 'formula'

class Nettle < Formula
  homepage 'http://www.lysator.liu.se/~nisse/nettle/'
  url 'http://ftpmirror.gnu.org/nettle/nettle-3.1.1.tar.gz'
  sha256 '5fd4d25d64d8ddcb85d0d897572af73b05b4d163c6cc49438a5bfbb8ff293d4c'

  head 'https://git.lysator.liu.se/nettle/nettle.git'

  head do
    depends_on 'autoconf' => :build
  end
  depends_on 'gmp'

  def install
    system './.bootstrap' if build.head?
    system './configure', "--prefix=#{prefix}",
                          '--enable-shared',
                          '--enable-public-key',
                          '--disable-openssl',
                          '--disable-documentation'
    system 'make'
    system 'make', 'install'
    system 'make', 'check'
  end
end
