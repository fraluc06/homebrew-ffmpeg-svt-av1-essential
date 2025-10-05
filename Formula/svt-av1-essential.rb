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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6014e6ec95994800b4e4fa0f048551af934776640f9dfa52607a6c20aae4779"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da1620bd80265abcae627a97af5336fd3afb0687f798923138030e790d9a6274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b81a842fd710d29b2063230fdd77012e2953db892257771168d5b3f46bc05284"
    sha256 cellar: :any_skip_relocation, ventura:       "f902700d3d16f68c67a3e8505cc81392ca0f7390116b048f9ec43bcbae9e8f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35fd05d292ccea2f88d3deff51c78a8ed0ca3dfd7b1178aa0a0fafa08c0fa941"
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
