class SvtAv1EssentialLib < Formula
  desc "SVT-AV1 encoder library (shared) - fork with sensible defaults"
  homepage "https://github.com/nekotrix/SVT-AV1-Essential"
  url "https://github.com/nekotrix/SVT-AV1-Essential/archive/refs/tags/v3.1.2-Essential.tar.gz"
  sha256 "34f081b6a9789ae823fa495cbcf55a12484c438eac43de22f4b55378d0bfee39"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
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
