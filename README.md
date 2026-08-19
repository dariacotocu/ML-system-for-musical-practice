# ML System for Musical Practice

A real-time, non-evaluative music practice system for guitarists — using personal-baseline autoencoders to reflect a musician's own expressive playing back to them via live generative visuals.

This research was accepted to the **Student Consortium at NIME 2026** (New Interfaces for Musical Expression).

---

## Overview

The system:
- Captures live guitar audio via microphone
- Extracts three interpretable features per moment: **loudness (RMS)**, **timbre (spectral centroid)**, and **rhythmic activity (onset strength)**
- Compresses each feature's short-term temporal shape through a small autoencoder
- Compares live playing against the musician's own baseline, rather than any external standard
- Streams the result via **OSC** to a **Processing** sketch, which renders an organic, evolving visual shape in real time


```
Microphone
   │
   ▼
Live feature extraction (librosa: RMS, spectral centroid, onset strength)
   │
   ▼
Personal autoencoders (one per feature, trained on the musician's own recordings)
   │
   ▼
Deviation from personal baseline
   │
   ▼
OSC ──────────────► Processing (real-time generative visual)
```

---

## Repository Structure

```
├── notebooks/                       # feature extraction, training, and analysis
├── models/                          # trained autoencoder weights (.pt)
├── live_processing_visualisation/   # Processing sketch (OSC receiver + visual)
├── live-integration.ipynb           # main live pipeline: mic → models → OSC
└── README.md
```

---

## Requirements

- Python 3.11
- [Processing](https://processing.org/) with the `oscP5` library
- Python packages: `torch`, `librosa`, `numpy`, `sounddevice`, `python-osc`, `scikit-learn`, `matplotlib`

---

## How to Run

**1. Open the Processing sketch**
Open `live_processing_visualisation/` in Processing and press Run. It listens for OSC messages on port `9000`.

**2. Run the live pipeline**
Open `live-integration.ipynb` and run the cells in order:
- Load the trained autoencoders (`models/`)
- Start the microphone stream
- Live features are extracted, encoded, and streamed to Processing as you play

---

