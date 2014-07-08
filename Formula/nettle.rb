require 'formula'

class Nettle < Formula
  homepage 'http://www.lysator.liu.se/~nisse/nettle/'
  url 'https://ftp.gnu.org/gnu/nettle/nettle-3.0.tar.gz'
  sha1 '0320ca758ac1fd9f4691064c11de78c8abb2ade3'

  head 'https://git.lysator.liu.se/nettle/nettle.git'

  head do
    depends_on :autoconf => :build
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
