class SvtAv1Essential < Formula
  desc "SVT-AV1 encoder CLI fork with FFMS2 support for direct video input"
  homepage "https://github.com/nekotrix/SVT-AV1-Essential"
  url "https://github.com/nekotrix/SVT-AV1-Essential/archive/refs/tags/v4.3.1-Essential.tar.gz"
  sha256 "a36fb1aa52886a1b2ef346a54ebd2014f372b988608a20034138b58f7deace3e"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/svt-av1-essential-4.3.1_1"
    sha256 cellar: :any, arm64_tahoe:  "78bca81b475b85c63eca3a89dce10e68c0383a2d893be0032f2cb85d840e9729"
    sha256 cellar: :any, x86_64_linux: "d8c62db7f9535ad2d56fbe329ce328bd5648024396f161c9dec1d8808a361262"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkgconf" => :build
  depends_on "fraluc06/ffmpeg-svt-av1-essential/ffms2"
  depends_on "fraluc06/ffmpeg-svt-av1-essential/hdr10plus-rs"
  depends_on "fraluc06/ffmpeg-svt-av1-essential/libdovi"

  def install
    args = [
      "-DCMAKE_BUILD_TYPE=Release",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DBUILD_SHARED_LIBS=OFF",
      "-DBUILD_APPS=ON",
      "-DBUILD_TOOLS=ON",
      "-DLIBDOVI_FOUND=ON",
      "-DLIBHDR10PLUS_RS_FOUND=ON",
      "-DSVT_AV1_LTO=ON",
      "-DENABLE_AVX512=OFF",
      "-DENABLE_NEON_I8MM=OFF",
      "-DREPRODUCIBLE_BUILDS=ON",
      "-DUSE_WEBM_IO=ON",
      "-DUSE_FFMS2=ON",
    ]

    system "cmake", "-S", ".", "-B", "svt_build", *args
    system "cmake", "--build", "svt_build", "--config", "Release", "--parallel"
    system "cmake", "--install", "svt_build"

    # We only want the CLI app from this formula
    # The libraries are provided by svt-av1-essential-lib
    rm_r([lib, include])
  end

  test do
    # Verify the binary is present and functional
    assert_match "SVT-AV1-Essential", shell_output("#{bin}/SvtAv1EncApp --version")

    # Try to open an empty file to see if FFMS2 support is active
    # (FFMS2 should return an error, but a different one than if it was missing)
    touch "empty.mp4"
    assert_match "FFMS2", shell_output("#{bin}/SvtAv1EncApp -i empty.mp4 2>&1", 1)
  end
end
