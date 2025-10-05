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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbf74b516e98fc55b287fbc7aecfd7d05e00f2b869451fc76931c454d4114a28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27e2eda6fd73eac1094509b8d386312b73213716bcd05fb854217badaf133a83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b03b7cac2f8b74adc2a501e1beb99a37a3e19912d03f3612969b29c10ec0944"
    sha256 cellar: :any_skip_relocation, ventura:       "280ccc9f18af8740f248395247d2681769c2cf3b9960f08baece208949204811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb266cb5eb5e5a36c59f3e124e6bf239484bf457f00816d41d750f8c72e8a2be"
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
