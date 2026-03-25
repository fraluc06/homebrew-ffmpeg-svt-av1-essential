class Ffms2Custom < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/refs/tags/5.0.tar.gz"
  sha256 "7770af0bbc0063f9580a6a5c8e7c51f1788f171d7da0b352e48a1e60943a8c3c"
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
