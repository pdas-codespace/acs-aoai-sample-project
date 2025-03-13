from flask import Flask, render_template, request, jsonify, redirect, url_for
from database import get_user_summaries, get_user_details
from acs_client import init_communication_client, make_call
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

@app.route('/')
def index():
    # Get user summaries from database
    users = get_user_summaries()
    return render_template('index.html', users=users)

@app.route('/user/<int:user_id>')
def user_details(user_id):
    # Get detailed info for a specific user
    user = get_user_details(user_id)
    if not user:
        return redirect(url_for('index'))
    return render_template('user_details.html', user=user)

@app.route('/api/make-call', methods=['POST'])
def initiate_call():
    data = request.json
    phone_number = data.get('phone_number')
    if not phone_number:
        return jsonify({"error": "Phone number is required"}), 400
    
    try:
        call_result = make_call(phone_number)
        return jsonify({"success": True, "result": call_result})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # Explicitly set port to 5000
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port, debug=True)