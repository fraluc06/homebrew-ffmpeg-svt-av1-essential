# FFmpeg-SVT-AV1-Essential

### This Homebrew tap provides formulae for **SVT-AV1-Essential** and a custom **FFmpeg** build bundled with it.

---

## Installation

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

### Automatic Bit-Depth Conversion
Automatically converts the input format to YUV420P10 when using 10-bit encoding on 8-bit sources.

### WebM Output (Default)
Supports automatic metadata pass-through and encoder parameter embedding specifically for WebM containers.

### Native FFMS2 Input Support
The `SvtAv1EncApp` can now read video formats (MP4, MKV, etc.) without the need for external tools, thanks to FFMS2 integration.

---

## Troubleshooting

If you encounter conflicts with standard Homebrew formulae, please uninstall the ffmpeg from [homebrew-core](https://formulae.brew.sh/formula/ffmpeg) first with the following command:
```bash
brew uninstall ffmpeg
```