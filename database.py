from flask_sqlalchemy import SQLAlchemy
import os
from dotenv import load_dotenv

load_dotenv()

# In a real application, you would set up proper database configuration
# For this demo, we'll use sample data
db = None

# Sample data for demonstration purposes
SAMPLE_USERS = [
    {
        'id': 1,
        'name': 'John Doe',
        'phone': '+15551234567',
        'email': 'john.doe@example.com',
        'status': 'Active'
    },
    {
        'id': 2,
        'name': 'Jane Smith',
        'phone': '+15559876543',
        'email': 'jane.smith@example.com',
        'status': 'Active'
    },
    {
        'id': 3,
        'name': 'Robert Johnson',
        'phone': '+15552223333',
        'email': 'robert.johnson@example.com',
        'status': 'Inactive'
    }
]

# Additional user details for the detailed view
USER_DETAILS = {
    1: {
        'id': 1,
        'name': 'John Doe',
        'phone': '+15551234567',
        'email': 'john.doe@example.com',
        'status': 'Active',
        'address': '123 Main St, Anytown, USA',
        'provider_type': 'Primary Care',
        'specialty': 'Family Medicine',
        'last_visit': '2023-04-15',
        'notes': 'Regular check-up every 6 months'
    },
    2: {
        'id': 2,
        'name': 'Jane Smith',
        'phone': '+15559876543',
        'email': 'jane.smith@example.com',
        'status': 'Active',
        'address': '456 Oak Ave, Somewhere, USA',
        'provider_type': 'Specialist',
        'specialty': 'Cardiology',
        'last_visit': '2023-06-22',
        'notes': 'Follow-up on cardiac assessment'
    },
    3: {
        'id': 3,
        'name': 'Robert Johnson',
        'phone': '+15552223333',
        'email': 'robert.johnson@example.com',
        'status': 'Inactive',
        'address': '789 Pine Rd, Elsewhere, USA',
        'provider_type': 'Specialist',
        'specialty': 'Dermatology',
        'last_visit': '2022-11-05',
        'notes': 'No longer accepting new patients'
    }
}

def get_user_summaries():
    """
    Get summary of all users
    In a real application, this would query the database
    """
    return SAMPLE_USERS

def get_user_details(user_id):
    """
    Get detailed information for a specific user
    In a real application, this would query the database with the user_id
    """
    return USER_DETAILS.get(user_id)

# For a real application, you would initialize and set up your database like this:
# def init_db(app):
#     global db
#     app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URI') 
#     app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
#     db = SQLAlchemy(app)
#     
#     class User(db.Model):
#         id = db.Column(db.Integer, primary_key=True)
#         name = db.Column(db.String(100), nullable=False)
#         phone = db.Column(db.String(20), nullable=False)
#         email = db.Column(db.String(100), nullable=False)
#         status = db.Column(db.String(20), nullable=False)
#         address = db.Column(db.String(200))
#         provider_type = db.Column(db.String(50))
#         specialty = db.Column(db.String(100))
#         last_visit = db.Column(db.Date)
#         notes = db.Column(db.Text)
#     
#     return db