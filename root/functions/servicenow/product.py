import requests


def fetch_all_products(instance, access_token):
    # Set the REST API endpoint for fetching incidents
    api_url = f"https://{instance}.service-now.com/api/now/table/cmdb_ci_business_app/product/list"

    # Set proper headers, including the access token
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {access_token}"
    }

    # Send GET request to retrieve all incidents from ServiceNow
    response = requests.get(api_url, headers=headers)

    # Check the status code of the response
    if response.status_code == 200:
        # Convert the response data to JSON format
        data = response.json()

        # Retrieve the incidents from the response
        products = data.get("result", {}).get(
            "cmdb_ci_business_app", [])
    else:
        # Raise an error if an error occurs while fetching the incidents
        response_data = response.json()
        error_message = response_data.get(
            "error", "Unknown error occurred while fetching incidents")
        raise Exception(
            f"Error occurred while fetching incidents: {error_message}")
    return products


def fetch_product_details(instance, access_token, product_number):
    api_url = f"https://{instance}.service-now.com/api/now/table/cmdb_ci_business_app/product/read"
    # Set proper headers, including the access token
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {access_token}"
    }

    # Send GET request to retrieve all incidents from ServiceNow
    params = {"product_id": product_number}
    response = requests.get(api_url, headers=headers, params=params)

    if response.status_code == 200:
        # Convert the response data to JSON format
        data = response.json()

        # Retrieve the incidents from the response
        products = data.get("result", {}).get("cmdb_ci_business_app", [])

        if not products:
            return None

        # Return the incidents
        return products[0]
    else:
        # Raise an error if an error occurs while fetching the incidents
        response_data = response.json()
        error_message = response_data.get(
            "error", "Unknown error occurred while fetching incidents")
        raise Exception(
            f"Error occurred while fetching incidents: {error_message}")
