class Kindletool < Formula
  desc "Tool for creating/extracting Kindle updates and more"
  homepage "https://github.com/NiLuJe/KindleTool"
  url "https://github.com/NiLuJe/KindleTool/archive/v1.6.4.tar.gz"
  sha256 "1876e13f33fe1026c51632ce3602ef8a011738af9ed7ed933fd18767f967da21"

  head "https://github.com/NiLuJe/KindleTool.git", :shallow => false

  depends_on "pkg-config" => :build

  depends_on "NiLuJe/kindletool/nettle"
  depends_on "NiLuJe/kindletool/libarchive"

  def install
    # Make sure the buildsystem will be able to generate a proper version tag
    ENV["GIT_DIR"] = cached_download/".git" if build.head?

    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=/."
  end
end
