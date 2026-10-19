# ML System for Musical Practice

A real-time, non-evaluative music practice system for guitarists. It compares a musician's live playing to a personal baseline learned from their own recordings, and reflects the result back as a live abstract visual. There is no scoring or grading, and no external standard.

This is the code for my MSc Applied Machine Learning for Creatives thesis, "A Non-Evaluative Machine Learning System for Supporting Musical Practice" (UAL Creative Computing Institute, 2026). The research was accepted to the Student Consortium at NIME 2026.

Demo video: https://www.youtube.com/watch?v=37q68BhtqNs

## How it works

1. Live guitar audio is captured from a microphone or audio interface.
2. Four features are extracted with librosa: loudness (RMS), brightness (spectral centroid), rhythmic activity (onset strength) and phrase continuity (inter-onset intervals).
3. RMS, centroid and onset each pass through their own small autoencoder, trained on the musician's own recordings. Phrase continuity doesn't use an autoencoder.
4. Each result is compared with the musician's personal baseline. RMS is sent as a raw value, as described in the thesis.
5. The values are sent by OSC to a Processing sketch, which draws a single shape that changes size, colour, wobble and position.

## Repository structure

- `live-integration.ipynb`: the main notebook, containing the full real-time pipeline
- `RMS/`, `Centroid/`, `ON-set/`: feature extraction notebooks, feature files and the trained autoencoder for each feature
- `onset-baseline/`: the phrase continuity baseline, the retraining notebook, and the calm-playing test from the "Evaluation Under Constraints" section of the thesis
- `thesis_visualisation/`: the Processing sketch


## Requirements

Python packages: `torch`, `librosa`, `numpy`, `sounddevice`, `soundfile`, `python-osc`, `scikit-learn`, `matplotlib`

Processing, with the `oscP5` and `netP5` libraries installed: https://processing.org/download

Hardware: a microphone or audio interface. An audio interface is recommended, as the built-in laptop microphone gave much less usable RMS values (see the thesis Results section). The audio device is set to index 0 in the notebook. Check the device list cell and change it to match your setup.

## How to run

1. Open `thesis_visualisation/thesis_visualisation.pde` in Processing and press Run. It listens for OSC on port 9000.
2. Open `live-integration.ipynb`. Run the setup cells in order (imports, model loading, baseline). Then run the first code cell, which starts the live pipeline.
3. Play. The shape responds to how your playing differs from your baseline.

## Not included

The recordings used to train and test the system (`daria-recordings/`) are my own playing and aren't included. The trained models and baseline files are included, so the live system runs without them. To build your own baseline, record your playing into `daria-recordings/` (the live notebook also saves each session to `daria-recordings/sessions/`) and run `retrain_all_models()` in `onset-baseline/retraining-for-baseline.ipynb`. It's commented out by default. Retraining overwrites the model files in `RMS/`, `Centroid/` and `ON-set/` and recomputes the baselines.

Two optional test cells in the live notebook read `daria-recordings/chitara-pt-cod.wav` and need your own recording.
