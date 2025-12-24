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
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/svt-av1-essential-3.1.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6114e36a1089e6939cab79a4dd0169a7341d198a0a96cfa85f8ab88adce9bfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ce854e792555f4baf5b261f4daa016736ccb2ff125b7950cfef4f8a26bd96f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86e5745b3e3125c4ea7552a8baf27b43f35a69ce62e2e1b7802ec765791becbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2024e1c07c31b48d33c109d1680c58ed1c714cf28f92d6e495b47722241c75"
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
