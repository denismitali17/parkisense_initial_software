# ParkiSense: Parkinson's Disease Voice Screening API

ParkiSense is a machine learning-powered mobile application that screens for Parkinson's disease through voice analysis. This repository contains the FastAPI backend that serves the trained Random Forest model via a REST API.

The full system consists of three components:

- **This repository**: FastAPI backend (Docker + Render)
- **Flutter app**: Android mobile frontend
- **Kaggle notebook**: ML training pipeline

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

## Video

The link to the YouTube video:

```
http://youtube.com/watch?v=1Nt_CpwLaZo 
```
---

## API Endpoints

| Method | Endpoint  | Description                           |
|--------|-----------|---------------------------------------|
| GET    | /         | Service info and status               |
| GET    | /health   | Health check                          |
| GET    | /features | Returns the list of required features |
| POST   | /predict  | Accepts features, returns prediction  |

### POST /predict: Request Body

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

## Deployment Plan

ParkiSense is deployed across two environments: the FastAPI backend on Render
and the Flutter app distributed as an Android APK.

### Backend Deployment (FastAPI + Docker + Render)

The backend is containerised using Docker and deployed to Render as a web
service. The deployment process is fully automated through GitHub integration.

**How it works:**

1. Code is pushed to the `main` branch on GitHub
2. Render detects the push and triggers an automatic rebuild
3. Docker builds the image using the `Dockerfile` in the `backend/` folder
4. The container starts and serves the FastAPI app on port 8000
5. Render exposes it at `https://parkisense-backend.onrender.com`

**Infrastructure:**

| Component     | Technology         |
|---------------|--------------------|
| Server        | Render (free tier) |
| Container     | Docker             |
| Runtime       | Python 3.11        |
| Framework     | FastAPI            |
| Model serving | joblib + scikit-learn |
| Root directory | `backend/`        |

**Environment:**

No environment variables are required. The model is loaded directly from
the `models/` folder inside the container at startup.

**To redeploy:**

Simply push to `main`. Render handles the rest automatically.

```bash
git add .
git commit -m "commit message"
git push
```

---

### Mobile App Deployment (Flutter + Android)

The Flutter app is built and distributed as an Android APK for testing
and demonstration purposes.

**To build a release APK:**

```bash
cd mobile/parkisense_app
flutter build apk --release
```

The APK will be generated at:

```
build/app/outputs/flutter-apk/app-release.apk
```

**To install on an Android device or emulator:**

```bash
flutter install
```

**Production deployment (future):**

For production release, the app would be submitted to the Google Play Store
following the standard Flutter Android release process. The backend URL in
`lib/constants.dart` would be updated to point to a production Render
instance running on a paid tier to avoid cold start delays.

---

### System Flow

```
User opens app
      ↓
Flutter records voice (44.1 kHz WAV)
      ↓
Acoustic features extracted in Dart
      ↓
POST /predict → Render (FastAPI backend)
      ↓
Model loads features → Random Forest inference
      ↓
Prediction + confidence returned as JSON
      ↓
Result displayed on screen
```


Render URL: `https://parkisense-backend.onrender.com`

---

## ML Training

The model was trained in a Kaggle notebook using:

- **Dataset 1**: UCI Parkinson's Disease Dataset (Little et al., 2009) — 195 voice recordings, 22 features
- **Dataset 2**: Parkinson's Speech with Multiple Types of Sound Recordings (Sakar et al., 2013) — 1,208 samples, 28 features
- **Pipeline**: scikit-learn, librosa, imbalanced-learn, joblib
- **Cross-validation**: Stratified 5-fold
- **Class imbalance**: SMOTE applied to training folds only

---

## Flutter App

The Flutter app is located in the parkinse_app directory.

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

## Author

Denis Mitali  
Supervisor: Simeon Nsabiyumva
