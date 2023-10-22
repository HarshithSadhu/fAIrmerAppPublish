import requests
from bs4 import BeautifulSoup
import json
import mysql.connector
import uuid
from flask import Flask, jsonify, request
from flask import Flask, request, jsonify

app = Flask(__name__)

# Sample data in memory for demonstration purposes
data = []


@app.route('/getCropData', methods=['POST'])
def getCropData(request):
    data = request.json
    connection = mysql.connector.connect(
        user='****',
        password='****',
        host='****',
        database='****',
    )

    # Create a cursor object to interact with the database
    cursor = connection.cursor()

    # Define the SQL query
    query = "SELECT r.consumerID, r.regionID, c.crop, c.sellingPricePer, c.yieldPer, r.acres, (r.acres * c.yieldPer * c.sellingPricePer) AS expectedRevenuePerYear FROM CropData AS c JOIN ConsumerData AS r ON c.regionID = r.regionID WHERE r.consumerID = %s and r.regionID = %s;"
    queryAspect = [data["consumerID"], data["regionID"]]
    cursor.execute(query, queryAspect)

    # Fetch all the results
    results = cursor.fetchall()

    # Create an array of JSON objects
    cropData = []
    for result in results:
        consumerID, regionID, crop, sellingPricePer, yieldPer, acres, expectedRevenuePerYear = result
        crop_json = {
            'consumerID': consumerID,
            'regionID': regionID,
            'crop': crop,
            'sellingPricePer': sellingPricePer,
            'yieldPer': yieldPer,
            'acres': acres,
            'expectedRevenuePerYear': expectedRevenuePerYear
        }
        cropData.append(crop_json)

    cursor.close()
    connection.close()

    # Create a JSON response
    response = {'cropData': cropData}

    return jsonify(response)


@app.route('/pushCustomer', methods=['POST'])
def pushCustomer(request):
    data = request.json
    connection = mysql.connector.connect(
        user='****',
        password='****',
        host='****',
        database='****',
    )

    # Create a cursor object to interact with the database
    cursor = connection.cursor()

    # Define the SQL query
    query = "INSERT INTO ConsumerData (consumerID, regionID, acres) VALUES (%s, %s, %s) " \
            "ON DUPLICATE KEY UPDATE regionID = %s, acres = %s"

    queryAspect = [data["consumerID"], data["regionID"], data["acres"], data["regionID"], data["acres"]]
    cursor.execute(query, queryAspect)
    connection.commit()
    cursor.close()
    connection.close()

    # Create a JSON response
    response = {'SUCCESSS': "Consumer Data Added or Updated"}

    return jsonify(response)




# GET endpoint to retrieve data
@app.route('/data', methods=['GET'])
def get_data():
    return jsonify(data)

# POST endpoint to add data


@app.route('/data', methods=['POST'])
def add_data(request):
    content = request.get_json()
    if content is None:
        return "Invalid JSON data", 400

    data.append(content)
    return "Data added", 201


if __name__ == '__main__':
    app.run(debug=True)
