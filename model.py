# model.py

from builtins import ValueError, enumerate, print, set, str
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import accuracy_score
import warnings
import os
import joblib

# Suppress warnings
warnings.filterwarnings("ignore")

class DrugPredictor:
    def __init__(self, data_path='DatasetML.csv', model_path='trained_model.pkl'):
        self.data_path = data_path
        self.model_path = model_path
        self.model = None
        self.scaler = None
        self.feature_columns = []
        self.label_encoders = {}
        self.drug_mapping = {}
        if os.path.exists(self.model_path):
            self.load_model()
        else:
            self.load_and_train()
            self.save_model()

    def load_and_train(self):
        # Load the dataset
        data = pd.read_csv(self.data_path)

        # Ensure 'Status' contains only the predefined categories
        valid_statuses = ['C', 'CL', 'D']
        data = data[data['Status'].isin(valid_statuses)]

        # Copy the dataset for preprocessing
        data_clean = data.copy()

        # Encode categorical variables using LabelEncoder
        categorical_cols = ['Drug', 'Sex', 'Ascites', 'Hepatomegaly', 'Spiders', 'Edema', 'Status']
        for col in categorical_cols:
            le = LabelEncoder()
            data_clean[col] = le.fit_transform(data_clean[col].astype(str))
            self.label_encoders[col] = le

        # Define features and target
        X = data_clean.drop(columns=['id', 'Drug'])  # Dropping 'id' and 'Drug' as 'Drug' is the target
        y = data_clean['Drug']  # Target variable

        # Standardize numerical features
        self.scaler = StandardScaler()
        X_scaled = self.scaler.fit_transform(X)

        # Split the dataset into training and testing sets (80% train, 20% test)
        X_train, X_test, y_train, y_test = train_test_split(
            X_scaled, y, test_size=0.2, random_state=60
        )

        # Train a Gradient Boosting Classifier
        self.model = GradientBoostingClassifier(n_estimators=100, random_state=40)
        self.model.fit(X_train, y_train)

        # Make predictions on the test set
        y_pred = self.model.predict(X_test)

        # Calculate accuracy
        accuracy = accuracy_score(y_test, y_pred)
        print(f"Gradient Boosting Model Accuracy: {accuracy * 100:.2f}%")

        # Drug mapping for inverse transformation
        drug_labels = self.label_encoders['Drug'].classes_
        self.drug_mapping = {
            index: label for index, label in enumerate(drug_labels)
        }

        # Save feature columns
        self.feature_columns = X.columns.tolist()

    def save_model(self):
        """
        Save the trained model, scaler, encoders, and feature columns to disk.
        """
        joblib.dump({
            'model': self.model,
            'scaler': self.scaler,
            'feature_columns': self.feature_columns,
            'label_encoders': self.label_encoders,
            'drug_mapping': self.drug_mapping
        }, self.model_path)
        print("Model saved successfully.")

    def load_model(self):
        """
        Load the trained model, scaler, encoders, and feature columns from disk.
        """
        data = joblib.load(self.model_path)
        self.model = data['model']
        self.scaler = data['scaler']
        self.feature_columns = data['feature_columns']
        self.label_encoders = data['label_encoders']
        self.drug_mapping = data['drug_mapping']
        print("Model loaded successfully.")

    def preprocess_input(self, input_data):
        """
        Preprocess the input data for prediction.
        :param input_data: dict containing feature values
        :return: Array ready for prediction
        """
        df = pd.DataFrame([input_data])

        # Encode categorical features if any
        for col in ['Sex', 'Ascites', 'Hepatomegaly', 'Spiders', 'Edema', 'Status']:
            if col in df.columns:
                try:
                    df[col] = self.label_encoders[col].transform([df[col].iloc[0]])[0]
                except ValueError:
                    # Handle unseen labels
                    df[col] = -1  # Or any other strategy

        # Drop 'id' if present (already excluded in features)
        if 'id' in df.columns:
            df = df.drop(columns=['id'])

        # Ensure all required features are present
        missing_features = set(self.feature_columns) - set(df.columns)
        for feature in missing_features:
            df[feature] = 0  # Or any default value

        # Reorder columns
        df = df[self.feature_columns]

        # Scale numerical features
        X_scaled = self.scaler.transform(df)

        return X_scaled

    def predict_drug(self, input_data):
        """
        Predict the drug based on input data.
        :param input_data: dict containing feature values
        :return: Predicted drug name
        """
        processed_data = self.preprocess_input(input_data)
        prediction = self.model.predict(processed_data)
        predicted_drug = self.drug_mapping.get(prediction[0], "Unknown")
        return predicted_drug
