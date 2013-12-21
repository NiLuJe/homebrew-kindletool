require 'formula'

class Nettle < Formula
  homepage 'http://www.lysator.liu.se/~nisse/nettle/'
  url 'http://www.lysator.liu.se/~nisse/archive/nettle-2.7.1.tar.gz'
  sha1 'e7477df5f66e650c4c4738ec8e01c2efdb5d1211'
  
  head 'git://git.lysator.liu.se/nettle/nettle.git'

  depends_on 'gmp'

  def install
    # Don't add -ggdb3 to the CFLAGS!
    inreplace 'configure', 'CFLAGS="$CFLAGS -ggdb3"', 'true'
    
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--enable-public-key",
                          "--disable-openssl"
    system "make"
    system "make install"
    system "make check"
  end
end
