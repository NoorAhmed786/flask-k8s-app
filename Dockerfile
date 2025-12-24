# Use a base Python image
FROM python:3.8-alpine

# Set the working directory inside the container
WORKDIR /app

RUN pip install --no-cache-dir flask==2.0.1 werkzeug==2.0.1


# Copy the current directory contents into the container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt


# Expose port 5000
EXPOSE 5000

# Define the command to run the app
CMD ["python", "app.py"]
