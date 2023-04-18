import requests


def authenticate(instance, username, password, client_id, client_secret):
    # ServiceNow OAuth 2.0 API endpoint
    oauth_url = f"https://{instance}.service-now.com/oauth_token.do"

    # Set proper headers
    headers = {"Content-Type": "application/x-www-form-urlencoded"}

    # Set payload for OAuth token request with username and password
    data = {
        "grant_type": "password",
        "client_id": client_id,
        "client_secret": client_secret,
        "username": username,
        "password": password
    }

    # Send POST request to retrieve access token and refresh token from ServiceNow
    response = requests.post(oauth_url, headers=headers, data=data)

    # Check the status code of the response
    if response.status_code == 200:
        # Convert the response data to JSON format
        data = response.json()

        # Retrieve the access token and refresh token from the response
        access_token = data.get("access_token")
        refresh_token = data.get("refresh_token")

        # Return the access token and refresh token
        return access_token, refresh_token
    else:
        # Raise an error if an error occurs while retrieving the access token and refresh token
        response_data = response.json()
        error_message = response_data.get(
            "error", "Unknown error occurred while retrieving access token and refresh token")
        raise Exception(
            f"Error occurred while retrieving access token and refresh token: {error_message}")


def refresh_token(instance, refresh_token, client_id, client_secret):
    # ServiceNow OAuth 2.0 API endpoint
    oauth_url = f"https://{instance}.service-now.com/oauth_token.do"

    # Set proper headers
    headers = {"Content-Type": "application/x-www-form-urlencoded"}

    # Set payload for OAuth token request with refresh token
    data = {
        "grant_type": "refresh_token",
        "client_id": client_id,
        "client_secret": client_secret,
        "refresh_token": refresh_token
    }

    # Send POST request to retrieve new access token from ServiceNow
    response = requests.post(oauth_url, headers=headers, data=data)

    # Check the status code of the response
    if response.status_code == 200:
        # Convert the response data to JSON format
        data = response.json()

        # Retrieve the new access token from the response
        new_access_token = data.get("access_token")

        # Return the new access token
        return new_access_token
    else:
        # Raise an error if an error occurs while updating the access token with the refresh token
        response_data = response.json()
        error_message = response_data.get(
            "error", "Unknown error occurred while updating access token with refresh token")
        raise Exception(
            f"Error occurred while updating access token with refresh token: {error_message}")
