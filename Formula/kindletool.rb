require 'formula'

# This is stolen^Winspired from mpv's Formula
# (https://github.com/mpv-player/homebrew-mpv/blob/master/Formula/mpv.rb)
class GitVersionWriter
  def initialize(downloader)
    @downloader = downloader
  end

  def write
    ohai "Generating VERSION file from Homebrew's git cache"
    git_revision
    FileUtils.mv("#{git_cache}/KindleTool/VERSION", 'VERSION')
  end

  private
  def git_revision
    system 'cd', "#{git_cache}/KindleTool"
    system './version.sh', 'PMS'
  end

  def git_cache
    @downloader.cached_location
  end
end

class Kindletool < Formula
  homepage 'https://github.com/NiLuJe/KindleTool'
  url 'https://github.com/NiLuJe/KindleTool/archive/v1.6.0.tar.gz'
  sha1 'fc305c91ca1d42db85cb60475dc4acd42d0122db'

  head 'https://github.com/NiLuJe/KindleTool.git'

  depends_on 'pkg-config' => :build
  depends_on 'NiLuJe/kindletool/libarchive'
  depends_on 'NiLuJe/kindletool/nettle'

  def install
    # NOTE: Leave my damn warnings alone! (noop with superenv)
    ENV.enable_warnings
    
    # Get a proper version tag
    GitVersionWriter.new(@downloader).write

    system 'make'
    system 'make', 'install', "DESTDIR=#{prefix}", 'PREFIX=/.'
  end
end
