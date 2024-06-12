import os
from flask import Flask, jsonify, request, render_template
from flask_cors import CORS
from tensorflow.keras.models import load_model  # Import the load_model function
import numpy as np

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

model = load_model("ridge_model.h5")

# Define the list of features
features = ['bedrooms', 'bathrooms', 'sqft_living', 'sqft_lot', 'floors', 'waterfront', 'view', 'condition',
            'sqft_above', 'sqft_basement', 'yr_built', 'yr_renovated']

@app.route('/')
def index():
    return render_template('index.html', features=features)

@app.route('/predict', methods=['POST'])
def predict():
    if request.method == 'POST':
        # Retrieve user input from the form
        try:
            bedrooms = float(request.form['bedrooms'])
            bathrooms = float(request.form['bathrooms'])
            sqft_living = float(request.form['sqft_living'])
            sqft_lot = float(request.form['sqft_lot'])
            floors = float(request.form['floors'])
            waterfront = float(request.form['waterfront'])
            view = float(request.form['view'])
            condition = float(request.form['condition'])
            sqft_above = float(request.form['sqft_above'])
            sqft_basement = float(request.form['sqft_basement'])
            yr_built = float(request.form['yr_built'])
            yr_renovated = float(request.form['yr_renovated'])
        except ValueError:
            # Return an error message if any input is invalid
            return jsonify({'error': 'Invalid input. Please enter valid numbers.'}), 400

        # Check if any input is empty or None
        if not all([bedrooms, bathrooms, sqft_living, sqft_lot, floors, waterfront, view, condition, sqft_above, sqft_basement, yr_built, yr_renovated]):
            return jsonify({'error': 'Invalid input. Please ensure all fields are filled out.'}), 400

        # Preprocess the input data
        user_input = np.array([[bedrooms, bathrooms, sqft_living, sqft_lot, floors, waterfront, view, condition,
                                sqft_above, sqft_basement, yr_built, yr_renovated]])

        # Make predictions
        predicted_price = model.predict(user_input)

        # Display the prediction
        return jsonify({'prediction': f"${predicted_price[0][0]:,.2f}"}), 200

if __name__ == '__main__':
    app.run(debug=True, port=8000)
