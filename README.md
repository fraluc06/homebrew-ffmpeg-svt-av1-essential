# FFmpeg-SVT-AV1-Essential

This Homebrew tap provides formulas to install **SVT-AV1-Essential** and a custom version of **FFmpeg** compiled with SVT-AV1-Essential.

---

## Installation

Install SVT-AV1-Essential:

```bash
brew install fraluc06/ffmpeg-svt-av1-essential/svt-av1-essential
```

Install custom FFmpeg with SVT-AV1-Essential included:

```bash
brew install fraluc06/ffmpeg-svt-av1-essential/ffmpeg-custom
```

---

## Verify Installation

Check the installed version of SVT-AV1-Essential:

```bash
SvtAv1EncApp --version
```

Expected output:

```
SVT-AV1 v3.1.2 (release)
```

Verify that FFmpeg is using SVT-AV1-Essential (for Bash and Zsh users):

```bash
ffmpeg -f lavfi -i testsrc=duration=1:size=128x128:rate=10 \
  -c:v libsvtav1 -preset 8 -crf 40 -y out.mkv -v verbose 2>&1 | grep SVT && rm -rf out.mkv
```

Expected output:
```
Svt[info]: SVT [version]: SVT-AV1-Essential Encoder Lib v3.1.2
Svt[info]: SVT [build]  : Apple LLVM 17.0.0 (clang-1700.0.13.5) 64 bit # or the version of clang you have installed
```

For Nushell users:

```nu
ffmpeg -f lavfi -i testsrc=duration=1:size=128x128:rate=10 -c:v libsvtav1 -preset 8 -crf 40 -y out.mkv -v verbose | complete | get stderr | lines | grep SVT; rm out.mkv
```

---

## ffms2 and SVT-AV1 Compatibility

### Why no ffms2 support in this tap?

[ffms2](https://github.com/FFMS/ffms2) is a video source library that depends on ffmpeg, which in turn depends on svt-av1 (standard). Since svt-av1-essential conflicts with svt-av1, you cannot have both installed simultaneously.

This is a hard dependency conflict:

```
ffms2→ ffmpeg → svt-av1 (standard) ← conflicts with → svt-av1-essential
```

Additionally, maintaining a fork of ffms2 that depends on ffmpeg-custom would create a circular dependency and is not sustainable.

### If you need ffms2

Use standard Homebrew ffmpeg with standard svt-av1:

```bash
brew install ffmpeg ffms2
```

This gives you ffms2 support with the standard AV1 encoder.

### If you want SVT-AV1-Essential

Use ffmpeg-custom from this tap:

```bash
brew install fraluc06/ffmpeg-svt-av1-essential/svt-av1-essential
brew install fraluc06/ffmpeg-svt-av1-essential/ffmpeg-custom
```

This gives you the optimized Essential encoder, but **without ffms2 support**.

### Why not both?

svt-av1-essential and svt-av1 install the same binaries and headers (`SvtAv1EncApp`, `libSvtAv1Enc`, headers). A `conflicts_with` prevents installation of both to avoid undefined behavior and symlink conflicts.

If you attempt to install ffms2 while svt-av1-essential is installed, Homebrew will report a conflict error.