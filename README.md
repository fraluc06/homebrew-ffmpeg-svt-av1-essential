# FFmpeg-SVT-AV1-Essential

This Homebrew tap provides high-performance formulae for **SVT-AV1-Essential** and a custom **FFmpeg** build optimized for modern AV1 encoding.

The project uses a "Bootstrapping" approach to resolve dependency loops between FFmpeg, FFMS2, and SVT-AV1, allowing for a fully integrated experience.

---

## Installation

To get the full suite with optimized FFmpeg and SvtAv1EncApp with direct video input support, follow this specific order:

### 1. Install the Shared Library
```bash
brew install fraluc06/ffmpeg-svt-av1-essential/svt-av1-essential-lib
```

### 2. Install Optimized FFmpeg
```bash
brew install fraluc06/ffmpeg-svt-av1-essential/ffmpeg-custom
```

### 3. Install Custom FFMS2
```bash
brew install fraluc06/ffmpeg-svt-av1-essential/ffms2-custom
```

### 4. Install the CLI Encoder (with FFMS2 Support)
```bash
brew install fraluc06/ffmpeg-svt-av1-essential/svt-av1-essential
```

---

## Verification

### Check Encoder Version & FFMS2 Support
```bash
SvtAv1EncApp --version
```
*Expected: `SVT-AV1-Essential v4.0.1 (release)`*

To verify direct input support, try encoding an MP4 file directly:
```bash
ffmpeg -f lavfi -i testsrc=duration=2:size=640x360:rate=24 -c:v libx264 test.mp4
SvtAv1EncApp --preset 10 -i test.mp4 -b test.ivf
```

### Verify FFmpeg Integration
Run this test command to ensure FFmpeg is correctly using the Essential encoder:

**Bash / Zsh:**
```bash
ffmpeg -f lavfi -i testsrc=duration=1:size=128x128:rate=10 \
  -c:v libsvtav1 -preset 8 -crf 40 -y out.mkv -v verbose 2>&1 | grep SVT && rm -rf out.mkv
```

---

## Key Features

### ✅ No More Dependency Conflicts
Unlike previous versions, you can now have **both** optimized `ffmpeg-custom` **and** `SvtAv1EncApp` with direct video input (FFMS2) installed simultaneously.

### Automatic Bit-Depth Conversion
Automatically converts input format to YUV420P10 when using 10-bit encoding on 8-bit sources.

### WebM Output (Default)
Enabled by default. Supports automatic metadata pass-through and encoder parameter embedding specifically for WebM containers.

### Native FFMS2 Input Support
The `SvtAv1EncApp` can read video formats (MP4, MKV, etc.) directly using our custom FFMS2 build, which is linked to your optimized FFmpeg.

---

## Troubleshooting

If you encounter conflicts with standard Homebrew formulas, you may need to unlink them first:
```bash
brew unlink ffmpeg svt-av1 ffms2
brew link --overwrite svt-av1-essential-lib ffmpeg-custom ffms2-custom svt-av1-essential
```
