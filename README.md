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