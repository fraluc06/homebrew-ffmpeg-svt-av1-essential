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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2936d75ce886792d0167d85a4fb5eb22be07b8ae73ae89c41bbde4f0af53bf58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc885ee50b11af191a0f1e5806c1a5ee05dc3a9576b7122f350761e77e9a6d92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "200944d674f3cb4fb1cea190ced1c90ae0366cd80725b1aa0a7e5bdcba993a00"
    sha256 cellar: :any_skip_relocation, ventura:       "5248642df91b4ec58e55945b9ab6a77c40eec91db485ac846b076d9de091d7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a3aaddd311d9bfec35badc67e96cbd961a27aa7871e902f27ff20ab8174631"
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
