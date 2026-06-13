# ParkiSense: Parkinson's Disease Voice Screening API

ParkiSense is a machine learning-powered mobile application that screens for Parkinson's disease through voice analysis. This repository contains the FastAPI backend that serves the trained Random Forest model via a REST API.

The full system consists of three components:

- **This repository** — FastAPI backend (Docker + Render)
- **Flutter app** — Android mobile frontend
- **Kaggle notebook** — ML training pipeline

---

## Live API

The backend is live at:

```
https://parkisense-backend.onrender.com
```

Swagger UI (interactive docs):

```
https://parkisense-backend.onrender.com/docs
```

---

## Project Structure

```
parkisense_initial_software/
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py
│   │   └── predictor.py
│   ├── models/
│   │   ├── parkisense_model.pkl
│   │   └── feature_names.pkl
│   ├── requirements.txt
│   └── Dockerfile
├── mobile/
│   └── parkisense_app/
│       ├── lib/
│       ├── android/
│       ├── pubspec.yaml
│       └── (all flutter files)
├── ML Track/
│   └── parkisense_notebook.ipynb
└── README.md
```

---

## Model Performance

The model was trained on the UCI Parkinson's Disease dataset (Little et al., 2009) using a Random Forest classifier with 5-fold stratified cross-validation and SMOTE for class imbalance correction.

| Metric    | Score  |
|-----------|--------|
| Accuracy  | 93.85% |
| Precision | 95.92% |
| Recall    | 95.92% |
| F1 Score  | 95.92% |
| AUC-ROC   | 96.19% |

Recall is the priority metric. In a screening context, missing a genuine Parkinson's case is more costly than a false positive.

---

## Features Used

The model uses 10 acoustic features selected by Random Forest feature importance:

1. PPE
2. spread1
3. MDVP:Fo(Hz)
4. spread2
5. MDVP:Flo(Hz)
6. MDVP:Fhi(Hz)
7. Jitter:DDP
8. NHR
9. MDVP:Jitter(Abs)
10. Shimmer:APQ5

---

## API Endpoints

| Method | Endpoint  | Description                           |
|--------|-----------|---------------------------------------|
| GET    | /         | Service info and status               |
| GET    | /health   | Health check                          |
| GET    | /features | Returns the list of required features |
| POST   | /predict  | Accepts features, returns prediction  |

### POST /predict — Request Body

```json
{
  "features": {
    "PPE": 0.284654,
    "spread1": -4.813031,
    "MDVP:Fo(Hz)": 119.992,
    "spread2": 0.266482,
    "MDVP:Flo(Hz)": 74.997,
    "MDVP:Fhi(Hz)": 157.302,
    "Jitter:DDP": 0.01109,
    "NHR": 0.02211,
    "MDVP:Jitter(Abs)": 0.00007,
    "Shimmer:APQ5": 0.03400
  }
}
```

### POST /predict — Response

```json
{
  "prediction": 1,
  "label": "Parkinson's Detected",
  "confidence": 95.92,
  "features_used": ["PPE", "spread1", "MDVP:Fo(Hz)", "spread2", "MDVP:Flo(Hz)", "MDVP:Fhi(Hz)", "Jitter:DDP", "NHR", "MDVP:Jitter(Abs)", "Shimmer:APQ5"]
}
```

---

## Local Setup

### Prerequisites

- Python 3.11
- pip

### Steps

```bash
# Clone the repository
git clone https://github.com/denismitali17/parkisense_initial_software
cd parkisense_initial_software
cd parkisense_backend

# Install dependencies
pip install -r requirements.txt

# Run the server
uvicorn app.main:app --reload
```

Open `http://localhost:8000/docs` to access the Swagger UI.

---

## Docker

```bash
# Build the image
docker build -t parkisense-backend .

# Run the container
docker run -p 8000:8000 parkisense-backend
```

---

## Deployment

The backend is deployed on **Render** using Docker.

### Deployment Steps

1. Push code to GitHub
2. Connect the repository to Render
3. Set runtime to Docker
4. Render builds and deploys automatically on every push to main

Render URL: `https://parkisense-backend.onrender.com`

---

## ML Training

The model was trained in a Kaggle notebook using:

- **Dataset 1** — UCI Parkinson's Disease Dataset (Little et al., 2009) — 195 voice recordings, 22 features
- **Dataset 2** — Parkinson's Speech with Multiple Types of Sound Recordings (Sakar et al., 2013) — 1,208 samples, 28 features
- **Pipeline** — scikit-learn, librosa, imbalanced-learn, joblib
- **Cross-validation** — Stratified 5-fold
- **Class imbalance** — SMOTE applied to training folds only

Kaggle notebook link: [insert link]

---

## Flutter App

The Android mobile app is in a separate repository.

Flutter app repo: [insert link]

It connects to this backend via the POST /predict endpoint, records voice samples at 44.1 kHz, extracts acoustic features, and displays the screening result with a confidence score.

---

## Tech Stack

| Layer    | Technology                      |
|----------|---------------------------------|
| Mobile   | Flutter (Dart) — Android        |
| Backend  | FastAPI (Python 3.11)           |
| ML       | scikit-learn, librosa, joblib   |
| Deployment | Docker + Render               |
| Training | Kaggle Notebooks (free GPU)     |

---

## Disclaimer

ParkiSense is a research prototype developed as part of a BSc Software Engineering capstone project at African Leadership University. It is not a validated medical device and should not be used as a substitute for professional medical advice. All results should be interpreted by a qualified healthcare professional.

---

## Author

Denis Mitali  
BSc Software Engineering — African Leadership University  
Supervisor: Simeon Nsabiyumva