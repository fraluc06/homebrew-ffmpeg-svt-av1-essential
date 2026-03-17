# FFmpeg-SVT-AV1-Essential

This Homebrew tap provides high-performance formulae for **SVT-AV1-Essential** and a custom **FFmpeg** build optimized for modern AV1 encoding.

---

## Installation

### 1. Install the Encoder
```bash
brew install fraluc06/ffmpeg-svt-av1-essential/svt-av1-essential
```

### 2. Install Optimized FFmpeg
```bash
brew install fraluc06/ffmpeg-svt-av1-essential/ffmpeg-custom
```

---

## Verification

### Check Encoder Version
```bash
SvtAv1EncApp --version
```
*Expected: `SVT-AV1-Essential v4.0.1 (release)`*

### Verify FFmpeg Integration
> [!NOTE]
> Run this test command only if you have installed `ffmpeg-custom`.

Run this test command to ensure FFmpeg is correctly using the Essential encoder:

**Bash / Zsh:**
```bash
ffmpeg -f lavfi -i testsrc=duration=1:size=128x128:rate=10 \
  -c:v libsvtav1 -preset 8 -crf 40 -y out.mkv -v verbose 2>&1 | grep SVT && rm -rf out.mkv
```

**Nushell:**
```nu
ffmpeg -f lavfi -i testsrc=duration=1:size=128x128:rate=10 -c:v libsvtav1 -preset 8 -crf 40 -y out.mkv -v verbose | complete | get stderr | lines | grep SVT; rm out.mkv
```

---

## Key Features

### Automatic Bit-Depth Conversion
Automatically converts input format to YUV420P10 when using 10-bit encoding on 8-bit sources.

### WebM Output (Default)
Enabled by default. Supports automatic metadata pass-through and encoder parameter embedding specifically for WebM containers.

### FFMS2 Input Support (Optional)
FFMS2 allows `SvtAv1EncApp` to read video formats (MP4, MKV, etc.) directly without needing to pipe through FFmpeg.

> [!WARNING]
> **Dependency Conflict:** FFMS2 requires the standard `ffmpeg` from Homebrew-core, which conflicts with `ffmpeg-custom`. You must choose between the optimized FFmpeg integration **OR** direct FFMS2 input support.

#### To Enable FFMS2 Support:
If you require direct input support, follow these steps to resolve conflicts:

1. **Clean up existing installs:**
   ```bash
   brew uninstall ffms2 svt-av1-essential ffmpeg-custom
   ```

2. **Reinstall with the FFMS2 flag:**
   ```bash
   brew reinstall fraluc06/ffmpeg-svt-av1-essential/svt-av1-essential --with-ffms2 --build-from-source
   ```

3. **Resolve Link Conflicts:**
   ```bash
   brew unlink svt-av1 && brew link --overwrite svt-av1-essential
   ```

**Resulting Environment:**
- ✅ `svt-av1-essential` (with FFMS2 support)
- ⚠️ Standard `ffmpeg` (Homebrew-core)
- ❌ Optimized `ffmpeg-custom` (Removed to avoid conflicts)

---

## Recommendation

For most users, the **Default Installation** is recommended as it provides the most optimized experience through FFmpeg integration:

```bash
brew install fraluc06/ffmpeg-svt-av1-essential/svt-av1-essential
brew install fraluc06/ffmpeg-svt-av1-essential/ffmpeg-custom
```
