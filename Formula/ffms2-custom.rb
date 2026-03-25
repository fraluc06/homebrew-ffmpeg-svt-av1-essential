class Ffms2Custom < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/refs/tags/5.0.tar.gz"
  sha256 "7770af0bbc0063f9580a6a5c8e7c51f1788f171d7da0b352e48a1e60943a8c3c"
  license "GPL-2.0-or-later"
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  bottle do
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/ffms2-custom-5.0"
    sha256 cellar: :any, arm64_tahoe:   "774b87a152228952e2a39d84db3d878731c3b8e28fdf50d5b4fc6ebca5ebb5d3"
    sha256 cellar: :any, arm64_sequoia: "91aedac3846218b21c114fe22cb2476aa12f7937cb188c7ad0ac557fe0f5a830"
    sha256 cellar: :any, arm64_sonoma:  "233a5e5c05076da555e36b2f75fb2a8b88dc4b1f4c60fd99afb96413bf196e60"
  end

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
    resource "homebrew-videosample" do
      url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
      sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
    end

    # download small sample and check that the index was created
    resource("homebrew-videosample").stage do
      system bin/"ffmsindex", "lm20.avi"
      assert_path_exists Pathname.pwd/"lm20.avi.ffindex"
    end
  end
end
