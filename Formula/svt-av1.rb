class SvtAv1 < Formula
  desc "AV1 encoder library (shared) - fork with sensible defaults"
  homepage "https://github.com/nekotrix/SVT-AV1-Essential"
  url "https://github.com/nekotrix/SVT-AV1-Essential/archive/refs/tags/v4.3.1-Essential.tar.gz"
  sha256 "a36fb1aa52886a1b2ef346a54ebd2014f372b988608a20034138b58f7deace3e"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/svt-av1-4.3.1"
    sha256 cellar: :any, arm64_tahoe:  "f3554dd67c7de550122385057f93b6fc45e86f588be737341623ab4491f9f0ea"
    sha256 cellar: :any, x86_64_linux: "a5a61a9f6e44a0178dff4ccf141cdf6f4819325b32aee8a1fbced2dfb9566a5d"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkgconf" => :build

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_INSTALL_LIBDIR=lib
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_APPS=OFF
      -DBUILD_TOOLS=OFF
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
      This library is used by ffmpeg for AV1 encoding.
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
