# MacBook Pro M5 Max Benchmark Results

- **Model**: Mac17,6 (MacBook Pro 16-inch, M5 Max, 2026)
- **CPU**: Apple M5 Max, 18 Cores (6P + 12E), 4.60 GHz
- **GPU**: 40-Core
- **RAM**: 128 GB
- **OS**: macOS 26.3.1 (Build 25D2128)
- **Tool**: Geekbench 6.6.0 for macOS AArch64
- **Date**: March 20, 2026

---

## CPU Benchmark

| Metric | Score |
|--------|-------|
| **Single-Core** | **4,328** |
| **Multi-Core** | **29,123** |

### Single-Core Details

| Test | Score | Throughput |
|------|-------|------------|
| File Compression | 3,616 | 519.2 MB/sec |
| Navigation | 3,554 | 21.4 routes/sec |
| HTML5 Browser | 4,552 | 93.2 pages/sec |
| PDF Renderer | 3,921 | 90.4 Mpixels/sec |
| Photo Library | 3,845 | 52.2 images/sec |
| Clang | 4,930 | 24.3 Klines/sec |
| Text Processing | 4,154 | 332.6 pages/sec |
| Asset Compression | 3,696 | 114.5 MB/sec |
| Object Detection | 6,390 | 191.2 images/sec |
| Background Blur | 4,568 | 18.9 images/sec |
| Horizon Detection | 4,456 | 138.7 Mpixels/sec |
| Object Remover | 5,406 | 415.6 Mpixels/sec |
| HDR | 4,989 | 146.4 Mpixels/sec |
| Photo Filter | 4,723 | 46.9 images/sec |
| Ray Tracer | 3,684 | 3.56 Mpixels/sec |
| Structure from Motion | 4,107 | 130.0 Kpixels/sec |

### Multi-Core Details

| Test | Score | Throughput |
|------|-------|------------|
| File Compression | 19,675 | 2.76 GB/sec |
| Navigation | 26,636 | 160.5 routes/sec |
| HTML5 Browser | 38,577 | 789.7 pages/sec |
| PDF Renderer | 32,064 | 739.5 Mpixels/sec |
| Photo Library | 37,806 | 513.1 images/sec |
| Clang | 54,129 | 266.6 Klines/sec |
| Text Processing | 5,526 | 442.6 pages/sec |
| Asset Compression | 43,643 | 1.32 GB/sec |
| Object Detection | 24,813 | 742.5 images/sec |
| Background Blur | 25,089 | 103.8 images/sec |
| Horizon Detection | 37,432 | 1.16 Gpixels/sec |
| Object Remover | 26,757 | 2.06 Gpixels/sec |
| HDR | 38,744 | 1.14 Gpixels/sec |
| Photo Filter | 25,474 | 252.8 images/sec |
| Ray Tracer | 50,202 | 48.6 Mpixels/sec |
| Structure from Motion | 36,016 | 1.14 Mpixels/sec |

---

## GPU Benchmark — OpenCL

| Metric | Score |
|--------|-------|
| **OpenCL Score** | **145,793** |

| Test | Score | Throughput |
|------|-------|------------|
| Background Blur | 62,179 | 257.3 images/sec |
| Face Detection | 55,645 | 181.7 images/sec |
| Horizon Detection | 178,084 | 5.54 Gpixels/sec |
| Edge Detection | 217,612 | 8.07 Gpixels/sec |
| Gaussian Blur | 203,561 | 8.87 Gpixels/sec |
| Feature Matching | 31,729 | 1.25 Gpixels/sec |
| Stereo Matching | 480,087 | 456.4 Gpixels/sec |
| Particle Physics | 490,964 | 21,607.7 FPS |

---

## GPU Benchmark — Metal

| Metric | Score |
|--------|-------|
| **Metal Score** | **223,290** |

| Test | Score | Throughput |
|------|-------|------------|
| Background Blur | 84,920 | 351.5 images/sec |
| Face Detection | 153,057 | 499.7 images/sec |
| Horizon Detection | 196,729 | 6.12 Gpixels/sec |
| Edge Detection | 279,509 | 10.4 Gpixels/sec |
| Gaussian Blur | 387,913 | 16.9 Gpixels/sec |
| Feature Matching | 59,381 | 2.34 Gpixels/sec |
| Stereo Matching | 711,376 | 676.2 Gpixels/sec |
| Particle Physics | 527,643 | 23,222.0 FPS |

---

## Summary vs Same Model Average

| Benchmark | My Score | Known Range | Assessment |
|-----------|----------|-------------|------------|
| CPU Single-Core | 4,328 | 4,268–4,297 | Above average |
| CPU Multi-Core | 29,123 | 29,043–29,233 | Average (center) |
| GPU OpenCL | 145,793 | ~145,412 | Average |
| GPU Metal | 223,290 | 218,772–232,718 | Average |
