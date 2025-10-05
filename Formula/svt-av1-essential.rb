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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e8c9830e0339d67ee143f04490ee1998565c77000209fb86ee3baee5654a136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb34524116db7cb64b725c5a77bd6138070a886a487964f91f18db78dc893d6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a682e46488b26afbd34c41f23254bdd14dd76fb98e3eec5af5800e77761abecc"
    sha256 cellar: :any_skip_relocation, ventura:       "b1f9b3732b21286968727fdd3bdf98185d03f0b4b91fefd2deecca9f87c793d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c0725b479467a2d9fc85057765a0cae1ea4710ea32b63ac717413ab67e48b72"
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
