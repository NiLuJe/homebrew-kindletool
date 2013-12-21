require 'formula'

class Libarchive < Formula
  homepage 'http://www.libarchive.org'
  url 'http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz'
  sha1 '6a991777ecb0f890be931cec4aec856d1a195489'

  head 'https://github.com/libarchive/libarchive.git'

  keg_only :provided_by_osx

  depends_on 'cmake' => :build
  depends_on 'xz' => :recommended
  # Make this a hard dep, there's no conditional to handle it w/ CMake...
  depends_on 'lzo'
  depends_on 'NiLuJe/kindletool/nettle' => :recommended
  depends_on 'expat' => :recommended
  depends_on :libxml2 if build.without? 'expat'

  def patches
    # Fixes issue 317 (bad fcntl API usage)
    "https://github.com/NiLuJe/KindleTool/raw/master/tools/libarchive-fix-issue-317.patch"
  end

  def install
    # Use the CMake buildsystem, to avoid issues when building HEAD
    # Make sure it doesn't choke on Homebrew's build type...
    inreplace 'CMakeLists.txt', 'Debug|Release|RelWithDebInfo|MinSizeRel', 'None|Debug|Release|RelWithDebInfo|MinSizeRel'
    
    # Set a bunch of defaults...
    args = std_cmake_args + %W[
          -DENABLE_TEST=OFF
          -DBUILD_TESTING=OFF
          -DENABLE_GTK=OFF
          -DENABLE_TAR=ON
          -DENABLE_XATTR=ON
          -DENABLE_ACL=ON
          -DENABLE_ICONV=ON
          -DENABLE_CPIO=ON
          -DENABLE_OPENSSL=OFF
          -DENABLE_ZLIB=ON
          -DENABLE_BZip2=ON
        ]

    # And then, handle our conditionals (they all defaults to ON)...
    args << '-DENABLE_NETTLE=OFF' unless build.with? 'NiLuJe/kindletool/nettle'
    args << '-DENABLE_LZMA=OFF'   unless build.with? 'xz'
    args << '-DENABLE_EXPAT=OFF'  unless build.with? 'expat'

    # We build in tree
    args << '.'

    # FIXME: Doesn't pass any CFLAGS at all (not even a lone -O2). Don't seem to care about our cmake args either...
    system 'cmake', *args
    system 'make'
    system 'make', 'install'
  end
end
