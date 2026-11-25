class Libdovi < Formula
  desc "C library for Dolby Vision metadata parsing and writing"
  homepage "https://github.com/quietvoid/dovi_tool"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/libdovi-3.4.0.tar.gz"
  sha256 "8eac4d1c3134f53e8eb216db6450307a737425844113e480d1e9713c142a9fa2"
  license "MIT"

  bottle do
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/libdovi-3.4.0"
    sha256 cellar: :any, arm64_tahoe:  "efbd16ac6b10e1da8603e3f3fe568bfc33bf15513876fbb8cb5d643a81fa8654"
    sha256 cellar: :any, x86_64_linux: "32da87d5a4f0d1b18ab094e5d5de552afd77fc54ee915ce64cefbc1803c4bab9"
  end

  depends_on "cargo-c" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    cd "dolby_vision" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--locked",
              "--features", "capi",
              "--prefix", prefix, "--libdir", lib
    end
  end

  test do
    assert_path_exists lib/shared_library("libdovi")
    assert_path_exists include/"libdovi/rpu_parser.h"
    assert_path_exists lib/"pkgconfig/dovi.pc"

    (testpath/"test.c").write <<~EOS
      #include <libdovi/rpu_parser.h>
      #include <stdio.h>
      int main(void) {
        const DoviRpuOpaqueList *r = dovi_parse_rpu_bin_file("nonexistent.bin");
        if (r) dovi_rpu_list_free(r);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldovi", "-o", "test"
    system "./test"
  end
end
