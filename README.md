# FFmpeg-SVT-AV1-Essential

This Homebrew tap provides formulas to install **SVT-AV1-Essential** and a custom version of **FFmpeg** compiled with SVT-AV1-Essential.

---

## Installation

Add the tap:

```bash
brew tap fraluc06/ffmpeg-svt-av1-essential
````

Install SVT-AV1-Essential:

```bash
brew install svt-av1-essential
```

Install custom FFmpeg with SVT-AV1-Essential included:

```bash
brew install ffmpeg-custom
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

Verify that FFmpeg is using SVT-AV1-Essential:

```bash
ffmpeg -encoders | grep svt
```

Expected output:

```
 V..... libsvtav1            SVT-AV1 Essential encoder
```

---