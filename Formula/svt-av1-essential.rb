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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48d79dca1b3fd8fdc0f4acc9986aa3fb11b138804c95e6d1563ea1cf51025aab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c88907d398a3e86cc17c2a2622085c05714b7e3b2e3ecde50d1a7834cbe4692"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbeefbcb21da01ef73d3e3caa0b7fe5686a1ea45d0742ca8f63a28ae16b456f9"
    sha256 cellar: :any_skip_relocation, ventura:       "3ea8ac638e629c2f64ea557d1ef76395f9f4cd2f337d70e97436c591411c8d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b26043ea18c1419de275dfb03fe91b10cd474b34c93a3b27fce3d33d4fe2ef8"
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
