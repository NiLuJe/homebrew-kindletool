require 'formula'

class Nettle < Formula
  homepage 'http://www.lysator.liu.se/~nisse/nettle/'
  url 'https://ftp.gnu.org/gnu/nettle/nettle-3.1.1.tar.gz'
  sha1 '1836601393522124787e029466935408e22dd204'

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
