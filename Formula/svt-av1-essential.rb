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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c7f4332794af1afa336b5710eb1adf054d1c873abfeded26e3cd4dcc2103282"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7214ea40fdaa683f560ffc58e948cdb9d780cec03aa5c3b75e43c7540058145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cf69c80553a02660d34eaf65da63f12daa2e8e795c66022f496fea08818af23"
    sha256 cellar: :any_skip_relocation, ventura:       "c4b8543aa56c5391f7a33820b772a4abe8c57af7b602e2774aec183e2429d87e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84c0645f678038f6dcf67eca80f5ebc68aa359a9c4b3ce82704970f695e182be"
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
