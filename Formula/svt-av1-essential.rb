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
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/svt-av1-essential-v3.1.2-bottles"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "273c2faa1ff0ad13426dfa507f005ec16b0218fdf72dd1ccd88e82db8cab8dc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84b8ab6d0cc579cfbd01a6d249f9455e45aebe7959e401a6efba62e08bb37f91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f807803169ef2d0acd739576edd60aa37950e6f88b12709041c404d43c4a29a"
    sha256 cellar: :any_skip_relocation, ventura:       "6a0730775c718114ba884f537071611df0e59ff5d1bdc9c90702338d9ac4aadb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48be2a3c2a62fd50a78f6dabd3e75833ea3c80d1c50e9980fb60ba03379d851d"
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
