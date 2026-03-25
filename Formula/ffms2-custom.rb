class Ffms2Custom < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin (custom build for SVT-AV1-Essential)"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/refs/tags/2.40.tar.gz"
  sha256 "82e95662946f3d6e1b529eadbd72bed196adfbc41368b2d50493efce6e716320"
  license "GPL-2.0-or-later"
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg-custom"

  conflicts_with "ffms2", because: "both install ffmsindex binary and ffms2 libraries"

  def install
    system "./autogen.sh", "--enable-avresample", *std_configure_args
    system "make", "install"
  end

  test do
    # Simple check for the binary
    system bin/"ffmsindex", "-h"
  end
end
