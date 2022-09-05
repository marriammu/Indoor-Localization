
from flask import Flask, jsonify, request
from flask_cors import CORS
import pandas as pd
import numpy as np
import openpyxl
import pickle
WifiReadings=[]
app = Flask(__name__)
CORS(app)
model = pickle.load(open('driving_model.pkl','rb'))
@app.route('/Readings', methods=['POST'])
def Data():

    request_data = request.get_json()
    print(request_data)
    WifiReadings=list(request_data.values())

    prediction = model.predict([WifiReadings])
    global output
    output = int(prediction[0])
    print("label")
    print(output)
    return jsonify(WifiReadings)


@app.route('/Readings', methods=['GET'])
def GetData():
 
    label = {"label": output}    
    return (jsonify(label))

if __name__ == "__main__":

    app.run(host="*********", port=80, debug=True)