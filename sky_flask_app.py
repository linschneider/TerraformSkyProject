from flask import Flask, jsonify, request
import psycopg2

app = Flask(__name__)
with open('dbpass', 'r') as file:
    password = file.read().strip()
    
#PostgreSQL database configuration
db_config = {
    'host': '10.0.1.4',
    'database': 'skydb',
    'user': 'skyuser',
    'pass': password,
}

def get_data_from_table():
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(**db_config)

        # Create a cursor
        cur = conn.cursor()

        # Fetch data from the "data" table
        cur.execute("SELECT * FROM data")
        table_data = cur.fetchall()

        # Close the cursor and connection
        cur.close()
        conn.close()

        return table_data

    except Exception as e:
        return str(e)

def insert_data_into_table(data):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(**db_config)

        # Create a cursor
        cur = conn.cursor()

        # Insert data into the "data" table
        insert_query = "INSERT INTO data (name, value, time) VALUES (%s, %s, %s)"
        cur.execute(insert_query, (data['name'], data['value'], data['time']))

        # Commit the transaction
        conn.commit()

        # Close the cursor and connection
        cur.close()
        conn.close()

        return "Data inserted successfully"

    except Exception as e:
        return str(e)

def delete_data_from_table(data_id):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(**db_config)

        # Create a cursor
        cur = conn.cursor()

        # Delete data from the "data" table
        delete_query = "DELETE FROM data WHERE id = %s"
        cur.execute(delete_query, (data_id,))

        # Commit the transaction
        conn.commit()

        # Close the cursor and connection
        cur.close()
        conn.close()

        return "Data deleted successfully"

    except Exception as e:
        return str(e)

@app.route('/data', methods=['GET'])
def show_data_from_table():
    table_data = get_data_from_table()
    return jsonify(table_data)

@app.route('/data', methods=['POST'])
def insert_data():
    new_data = request.json
    result = insert_data_into_table(new_data)
    return jsonify({"message": result})

@app.route('/data/<int:data_id>', methods=['DELETE'])
def delete_data(data_id):
    result = delete_data_from_table(data_id)
    return jsonify({"message": result})

if __name__ == '__main__':
    app.run(debug=True)


