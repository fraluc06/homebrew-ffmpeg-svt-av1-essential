class SvtAv1EssentialLib < Formula
  desc "SVT-AV1 encoder library (shared) - fork with sensible defaults"
  homepage "https://github.com/nekotrix/SVT-AV1-Essential"
  url "https://github.com/nekotrix/SVT-AV1-Essential/archive/refs/tags/v4.0.1-Essential.tar.gz"
  sha256 "4575b5b50eb6888f358d235e44c6caf1a968812ce2200692b2025e5ea082244b"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/svt-av1-essential-lib-4.0.1"
    sha256 cellar: :any,                 arm64_tahoe:   "0f3ded82027d2e2f220dfcc5878d09b7df4b3f9c7ddcdec8a63c24b8cbc85561"
    sha256 cellar: :any,                 arm64_sequoia: "16dc389d4eda9301edfece35df846f5cad4d7f8364f0a5542a5f58f96cf6b7be"
    sha256 cellar: :any,                 arm64_sonoma:  "7fe3e96b6a498c08c7a33357890392cd0c935ff66f77e9300973ae9b3096a044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15add2b703c3ed70b71daa60c8ecabe761caa0a5af851ea261d0828683c0a4c3"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkgconf" => :build

  conflicts_with "svt-av1", because: "both install SVT-AV1 libraries"

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_INSTALL_LIBDIR=lib
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_APPS=OFF
      -DBUILD_DEC=OFF
      -DSVT_AV1_LTO=ON
      -DENABLE_AVX512=OFF
      -DENABLE_NEON_I8MM=OFF
      -DREPRODUCIBLE_BUILDS=ON
      -DUSE_WEBM_IO=OFF
    ]

    system "cmake", "-S", ".", "-B", "svt_build", *args
    system "cmake", "--build", "svt_build", "--config", "Release", "--parallel"
    system "cmake", "--install", "svt_build"
  end

  def caveats
    <<~EOS
      SVT-AV1-Essential library (shared) has been installed.
      This library is used by ffmpeg-custom for AV1 encoding.
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <svt-av1/EbSvtAv1Enc.h>
      int main() {
        EbSvtAv1EncConfiguration config;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lSvtAv1Enc", "-o", "test"
    system "./test"
  end
end
