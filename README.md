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

## SVT-AV1-Essential Features

### WebM Output Support (Enabled by Default)

SVT-AV1-Essential is built with WebM output support enabled, allowing automatic metadata pass-through and encoder parameter embedding in WebM containers.

### FFMS2 Input Support (Optional)

FFMS2 enables direct video input support for formats like MP4, MKV, and more, without piping through FFmpeg.

#### ⚠️ Important: Dependency Conflict

**FFMS2 requires standard `ffmpeg` from homebrew-core, which conflicts with `ffmpeg-custom`.**

If you want FFMS2 support, you must:
1. **Uninstall** `ffmpeg-custom` and `svt-av1-essential` first
2. **Accept** that you will get the standard `ffmpeg` and standard `svt-av1` (NOT essential)

```bash
# Uninstall this tap's packages
brew uninstall ffmpeg-custom
brew uninstall svt-av1-essential

# Reinstall svt-av1-essential with FFMS2 support (will install standard ffmpeg + svt-av1)
brew reinstall fraluc06/ffmpeg-svt-av1-essential/svt-av1-essential --with-ffms2 --build-from-source
```

**You will end up with:**
- `svt-av1-essential` (built with FFMS2 support)
- Standard `ffmpeg` from homebrew-core (NOT ffmpeg-custom)
- Standard `svt-av1` from homebrew-core (conflicts with svt-av1-essential are handled)

#### Usage with FFMS2:

```bash
# Direct input from various formats
SvtAv1EncApp -i input.mp4 -b output.ivf --crf 30
SvtAv1EncApp -i input.mkv -b output.ivf --crf 30
```

#### Comparison

| Feature | `svt-av1-essential` + `ffmpeg-custom` | `svt-av1-essential --with-ffms2` |
|---------|---------------------------------------|-----------------------------------|
| SVT-AV1 version | Essential (optimized) | Essential (optimized) |
| FFmpeg version | Custom (with SVT-AV1-Essential) | Standard (homebrew-core) |
| FFMS2 input | ❌ No | ✅ Yes |
| WebM output | ✅ Yes | ✅ Yes |

---

## ffms2 and SVT-AV1 Compatibility

### Default Installation (Recommended)

For the optimized Essential encoder with full FFmpeg integration:

```bash
brew install fraluc06/ffmpeg-svt-av1-essential/svt-av1-essential
brew install fraluc06/ffmpeg-svt-av1-essential/ffmpeg-custom
```

This gives you:
- SVT-AV1-Essential optimized encoder
- WebM output support
- Full FFmpeg integration via `ffmpeg-custom`

### If You Need FFMS2

FFMS2 is **not compatible** with `ffmpeg-custom` due to dependency conflicts:

```
ffms2 → ffmpeg (standard) → svt-av1 (standard) ← conflicts with → svt-av1-essential
```

**Option 1: Use this tap with FFMS2 (advanced)**
```bash
brew uninstall ffmpeg-custom
brew reinstall fraluc06/ffmpeg-svt-av1-essential/svt-av1-essential --with-ffms2 --build-from-source
```
You'll get SVT-AV1-Essential but must use standard ffmpeg (not ffmpeg-custom).

**Option 2: Use standard Homebrew stack**
```bash
brew install ffmpeg ffms2
```
You'll get standard ffmpeg with standard svt-av1 (not essential).

### Why Not Both?

`svt-av1-essential` and `svt-av1` install the same binaries (`SvtAv1EncApp`, libraries, headers). A `conflicts_with` prevents installing both simultaneously.

`ffmpeg-custom` conflicts with `ffmpeg`, so you cannot have both installed at the same time.