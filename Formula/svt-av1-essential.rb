class SvtAv1Essential < Formula
  desc "SVT-AV1 encoder fork with sensible defaults"
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
  depends_on "ffms2" => :optional

  conflicts_with "svt-av1", because: "both install SvtAv1EncApp and SVT-AV1 libraries"

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
      "-DUSE_WEBM_IO=ON",
    ]

    args << "-DUSE_FFMS2=ON" if build.with? "ffms2"

    system "cmake", "-S", ".", "-B", "svt_build", *args
    system "cmake", "--build", "svt_build", "--config", "Release", "--parallel"
    system "cmake", "--install", "svt_build"
  end

  def caveats
    if build.with? "ffms2"
      <<~EOS
        Built with FFMS2 support for direct video input (MP4, MKV, etc.).

        WARNING: This requires standard ffmpeg from homebrew-core.
        You must uninstall ffmpeg-custom first:
          brew uninstall ffmpeg-custom

        This will also install standard svt-av1 as a dependency of ffmpeg.
      EOS
    else
      <<~EOS
        Built with WebM output support enabled.

        This formula conflicts with svt-av1 and is optimized for use with ffmpeg-custom.

        For FFMS2 input support, reinstall with:
          brew reinstall svt-av1-essential --with-ffms2 --build-from-source

        NOTE: FFMS2 requires uninstalling ffmpeg-custom first and using standard ffmpeg.
      EOS
    end
  end

  test do
    system "#{bin}/SvtAv1EncApp", "--version"
  end
end
