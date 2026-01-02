class SvtAv1Essential < Formula
  desc "SVT-AV1 encoder fork with sensible defaults"
  homepage "https://github.com/nekotrix/SVT-AV1-Essential"
  url "https://github.com/nekotrix/SVT-AV1-Essential/archive/refs/tags/v3.1.2-Essential.tar.gz"
  version "3.1.2-Essential"
  sha256 "34f081b6a9789ae823fa495cbcf55a12484c438eac43de22f4b55378d0bfee39"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-Essential)$/i)
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/svt-av1-essential-3.1.2-Essential"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10c0ce85ab8165c80a3943d58e91c7654080f73cc30cafe1c8c69fe3a9942612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c372d3ddf578fb7b7c3b34322c9a6a8c2bd9ca1110c5292f2963439c9df0b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ed5c5495a80441ffbd7701f1789bba9ff4cbca6ad11f825de2ebcced2b7fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d85c1c6920c98d9a8a20544f8ed883cbe3f748cfd75c0e0a094c911681cf67"
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
