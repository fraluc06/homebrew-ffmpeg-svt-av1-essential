class SvtAv1Essential < Formula
  desc "SVT-AV1 encoder fork with sensible defaults"
  homepage "https://github.com/nekotrix/SVT-AV1-Essential"
  url "https://github.com/nekotrix/SVT-AV1-Essential/archive/refs/tags/v3.1.2-Essential.tar.gz"
  sha256 "34f081b6a9789ae823fa495cbcf55a12484c438eac43de22f4b55378d0bfee39"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-Essential)$/i)
  end

  bottle do
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/svt-av1-essential-v3.1.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30e3cd619d33b498940d303dda254d55e0622adbe4374b1f08b6b1a34a7d37c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ca090537428f084ec4ec348759104c52318014c9f0b76e8df7391c880b6e09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5165a57ff121d5207493f3db0cb443b8b7f32d25f8b5515f0fef3c33fbb2688d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f45479f24595d0a8871265b8b9264a96eabf27ded2c439c074b8b7dba6ebdf0d"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    args = [
      "-DCMAKE_BUILD_TYPE=Release",
      "-DCMAKE_C_COMPILER=clang",
      "-DCMAKE_CXX_COMPILER=clang++",
      "-DBUILD_SHARED_LIBS=OFF",
      "-DSVT_AV1_LTO=ON",
      "-DENABLE_AVX512=OFF",
      "-DENABLE_NEON_I8MM=OFF",
      "-DBUILD_DEC=OFF",
      "-DREPRODUCIBLE_BUILDS=ON",
      "-DCMAKE_C_FLAGS_RELEASE=-O3 -DNDEBUG",
      "-DCMAKE_CXX_FLAGS_RELEASE=-O3 -DNDEBUG",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
    ]

    system "cmake", "-S", ".", "-B", "svt_build", *args
    system "cmake", "--build", "svt_build", "--config", "Release", "--parallel"
    system "cmake", "--install", "svt_build"
  end

  test do
    system "#{bin}/SvtAv1EncApp", "--version"
  end
end
