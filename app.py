# app.py

from builtins import ValueError, float
from flask import Flask, render_template, request
from model import DrugPredictor

app = Flask(__name__)

# Initialize the DrugPredictor
predictor = DrugPredictor(data_path='DatasetML.csv')

@app.route('/')
def home():
    return render_template(
        'form.html',
        features=predictor.feature_columns,
        error=None,
        title="Drug Prediction for Liver Disease Patients"
    )

@app.route('/predict', methods=['POST'])
def predict():
    patient_data = {}
    error_message = None

    for feature in predictor.feature_columns:
        value = request.form.get(feature)
        if value is None or value.strip() == '':
            error_message = f"Missing value for feature '{feature}'. Please fill out all fields."
            break
        # Handle categorical features
        if feature in ['Sex', 'Ascites', 'Hepatomegaly', 'Spiders', 'Edema', 'Status']:
            patient_data[feature] = value.strip()  # Keep as string for encoding
        else:
            try:
                # Convert numerical inputs to float
                patient_data[feature] = float(value)
            except ValueError:
                error_message = f"Invalid value for feature '{feature}': '{value}'. Please enter valid numerical values."
                break

    if error_message:
        return render_template(
            'form.html',
            features=predictor.feature_columns,
            error=error_message,
            previous_input=request.form,
            title="Drug Prediction for Liver Disease Patients"
        )

    # Predict the drug
    predicted_drug = predictor.predict_drug(patient_data)

    return render_template(
        'result.html',
        predicted_drug=predicted_drug,
        title="Drug Prediction for Liver Disease Patients"
    )

if __name__ == '__main__':
    app.run(debug=True)
