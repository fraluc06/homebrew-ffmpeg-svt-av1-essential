class SvtAv1Essential < Formula
  desc "SVT-AV1 encoder CLI fork with FFMS2 support for direct video input"
  homepage "https://github.com/nekotrix/SVT-AV1-Essential"
  url "https://github.com/nekotrix/SVT-AV1-Essential/archive/refs/tags/v3.1.2-Essential.tar.gz"
  sha256 "34f081b6a9789ae823fa495cbcf55a12484c438eac43de22f4b55378d0bfee39"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkgconf" => :build
  depends_on "ffms2-custom"

  conflicts_with "svt-av1", because: "both install SvtAv1EncApp"

  def install
    args = [
      "-DCMAKE_BUILD_TYPE=Release",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DBUILD_SHARED_LIBS=OFF",
      "-DBUILD_APPS=ON",
      "-DBUILD_DEC=OFF",
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
