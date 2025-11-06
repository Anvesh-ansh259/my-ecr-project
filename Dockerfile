# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Copy dependency file and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app files
COPY . .

# Expose Flask default port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]

