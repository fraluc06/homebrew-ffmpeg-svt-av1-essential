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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba2b332d758793f90ad1ecadfab348f6dba14d9e289668fae4290eccba9b0adf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb1bb025a77f5025d3ab2d3d6cfabc664e1232314bf680012002782ef043dfdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36fa545efff321add2b0373e304c7a53c869b3e9585daf248c7366cabfeb7a78"
    sha256 cellar: :any_skip_relocation, ventura:       "fee4e2378b64ca9434038fc5fc933058dd3d7aee8f59545a25cf816a3b92d310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2bdbe3e9efae383fd53440249f6af009ddb77a7c5b7acfacffcf219a1f655bd"
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
