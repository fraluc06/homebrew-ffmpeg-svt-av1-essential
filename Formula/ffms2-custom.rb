class Ffms2Custom < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/refs/tags/5.0.tar.gz"
  sha256 "7770af0bbc0063f9580a6a5c8e7c51f1788f171d7da0b352e48a1e60943a8c3c"
  license "GPL-2.0-or-later"
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/ffms2-custom-5.0"
    sha256 cellar: :any,                 arm64_tahoe:   "9179b9428b8fe2d7673a3fe93f46da7cd9f81c4094b5b2c8ba5d14b23b39d590"
    sha256 cellar: :any,                 arm64_sequoia: "c7d17cc982b8a9da5a8569c961bd049631e34176fd65210102e53da436483d4f"
    sha256 cellar: :any,                 arm64_sonoma:  "8af56e4ea3b65a89b97ba53cd0b27feef37622f54e9fd51be0dd85ca7f3ac4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d970ac45a9913417807cc5f2e496c641c011f725dc2c57ca550662f15f00dc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg-custom"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
