#!/bin/bash

# Define function name and runtime
function_name="wiz_lambda"
runtime="python3.9"

echo "Creating directory for the lambda function..."
# Create a directory to store the lambda function code
dir_name="lambda_function"
mkdir -p $dir_name

echo "Creating virtual environment for dependencies..."
# Create and activate a virtual environment for dependencies
python -m venv venv_$function_name
venv_$function_name/Scripts/activate

# Install dependencies from requirements.txt if it exists
FILE="requirements.txt"
if [ -f "$FILE" ]; then
  echo "Installing dependencies from requirements.txt..."
  pip install -r "$FILE"
else
  echo "Error: requirements.txt not found!"
  exit 1
fi

echo "Deactivating virtual environment..."
# Deactivate the virtual environment
# deactivate
venv_$function_name/Scripts/deactivate.bat


echo "Copying lambda function code into deployment package..."
# Copy the necessary files into the deployment package directory
cp ./*.py $dir_name
cp -r venv_$function_name/Lib/site-packages/* $dir_name/

echo "Removing virtual environment folder..."
# Remove the virtual environment folder
rm -rf venv_$function_name

echo "Deployment package created successfully!"
