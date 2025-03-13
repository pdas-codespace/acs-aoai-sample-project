import os
from azure.communication.identity import CommunicationIdentityClient
from azure.communication.callautomation import (
    CallAutomationClient,
    CallInvite
)
from dotenv import load_dotenv

load_dotenv()

# Global clients
identity_client = None
call_automation_client = None

def init_communication_client():
    """Initialize the Azure Communication Services clients"""
    global identity_client, call_automation_client
    
    connection_string = os.getenv("AZURE_COMMUNICATION_CONNECTION_STRING")
    if not connection_string:
        raise ValueError("Azure Communication Services connection string not found in environment variables")
    
    # Initialize the clients if they haven't been initialized yet
    if not identity_client:
        identity_client = CommunicationIdentityClient.from_connection_string(connection_string)
    
    if not call_automation_client:
        call_automation_client = CallAutomationClient.from_connection_string(connection_string)
    
    return identity_client, call_automation_client

def make_call(target_phone_number):
    """
    Make a call to the specified phone number using Azure Communication Services
    
    Args:
        target_phone_number (str): The phone number to call in E.164 format (e.g., +15551234567)
    
    Returns:
        dict: Information about the initiated call
    """
    try:
        # Initialize clients if not already done
        _, call_client = init_communication_client()
        
        # Create a call connection
        source_phone_number = os.getenv("ACS_PHONE_NUMBER")
        if not source_phone_number:
            raise ValueError("Source phone number not found in environment variables")
        
        # Event callback URL for call events - this would be your webhook endpoint in a production environment
        callback_url = os.getenv("CALLBACK_URL", "https://example.com/api/callbacks")
        
        # Create a call invite
        call_invite = CallInvite(
            target_phone_number=target_phone_number,
            source_phone_number=source_phone_number
        )
        
        # Create call connection
        call_connection = call_client.create_call(
            target_participant=call_invite,
            callback_url=callback_url
        )
        
        # Return call information
        return {
            "call_connection_id": call_connection.call_connection_id,
            "status": "initiated",
            "target_phone_number": target_phone_number
        }
        
    except Exception as e:
        print(f"Error making call: {str(e)}")
        raise