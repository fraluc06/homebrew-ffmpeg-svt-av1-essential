class Hdr10plusRs < Formula
  desc "C library for HDR10+ metadata parsing and writing"
  homepage "https://github.com/quietvoid/hdr10plus_tool"
  url "https://github.com/quietvoid/hdr10plus_tool/archive/refs/tags/libhdr10plus-2.1.5.tar.gz"
  sha256 "fd2b979d9f8afe4d547c8bf53f338a67f4cb741984a0784f04d7e244f80a36c7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^libhdr10plus-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/fraluc06/homebrew-ffmpeg-svt-av1-essential/releases/download/hdr10plus-rs-2.1.5"
    sha256 cellar: :any, arm64_tahoe:  "f32a35b8a1ef3acd07f4b042c86d72926b9580e207290a5d9b00e0bbbf8b8044"
    sha256 cellar: :any, x86_64_linux: "30503fb809b1f09a43de00d51f33a459543598b9a798e3bfd21ba47e7954d7b1"
  end

  depends_on "cargo-c" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    cd "hdr10plus" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release",
              "--features", "capi",
              "--prefix", prefix, "--libdir", lib
    end
  end

  test do
    assert_path_exists lib/shared_library("libhdr10plus-rs")
    assert_path_exists include/"libhdr10plus-rs/hdr10plus.h"
    assert_path_exists lib/"pkgconfig/hdr10plus-rs.pc"

    (testpath/"test.c").write <<~EOS
      #include <libhdr10plus-rs/hdr10plus.h>
      #include <stdio.h>
      int main(void) {
        Hdr10PlusRsJsonOpaque *j = hdr10plus_rs_parse_json("nonexistent.json");
        if (j) hdr10plus_rs_json_free(j);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhdr10plus-rs", "-o", "test"
    system "./test"
  end
end
