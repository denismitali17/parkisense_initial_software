import joblib
import numpy as np
from pathlib import Path

MODEL_PATH    = Path(__file__).parent.parent / "models" / "parkisense_model.pkl"
FEATURES_PATH = Path(__file__).parent.parent / "models" / "feature_names.pkl"

model         = joblib.load(MODEL_PATH)
feature_names = joblib.load(FEATURES_PATH)

def predict_from_features(features: dict) -> dict:
    """
    Takes a dict of feature_name -> value
    Returns prediction and confidence score
    """
    try:
        feature_vector = np.array([[features[f] for f in feature_names]])
    except KeyError as e:
        raise ValueError(f"Missing feature: {e}")

    prediction   = model.predict(feature_vector)[0]
    probabilities = model.predict_proba(feature_vector)[0]
    confidence   = float(probabilities[int(prediction)])

    return {
        "prediction":   int(prediction),
        "label":        "Parkinson's Detected" if prediction == 1 else "Healthy",
        "confidence":   round(confidence * 100, 2),
        "features_used": feature_names,
    }