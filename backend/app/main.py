from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Dict
from app.predictor import predict_from_features, feature_names

app = FastAPI(
    title="ParkiSense API",
    description="ML-powered Parkinson's Disease screening via voice features",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


# Request
class FeaturesInput(BaseModel):
    features: Dict[str, float]

    class Config:
        json_schema_extra = {
            "example": {
                "features": {
                    "PPE":               0.284654,
                    "spread1":          -4.813031,
                    "MDVP:Fo(Hz)":      119.992,
                    "spread2":           0.266482,
                    "MDVP:Flo(Hz)":     74.997,
                    "MDVP:Fhi(Hz)":    157.302,
                    "Jitter:DDP":        0.01109,
                    "NHR":               0.02211,
                    "MDVP:Jitter(Abs)":  0.00007,
                    "Shimmer:APQ5":      0.03400,
                }
            }
        }


class PredictionResponse(BaseModel):
    prediction:    int
    label:         str
    confidence:    float
    features_used: list


#Endpoints
@app.get("/")
def root():
    return {
        "service": "ParkiSense API",
        "status":  "running",
        "version": "1.0.0",
    }


@app.get("/health")
def health():
    return {"status": "healthy"}


@app.get("/features")
def get_features():
    """Returns the list of features the model expects."""
    return {
        "required_features": feature_names,
        "count": len(feature_names),
    }


@app.post("/predict", response_model=PredictionResponse)
def predict(input_data: FeaturesInput):
    """
    Accepts a JSON body with a 'features' dict.
    Returns prediction, label, and confidence score.
    """
    try:
        result = predict_from_features(input_data.features)
        return result
    except ValueError as e:
        raise HTTPException(status_code=422, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")