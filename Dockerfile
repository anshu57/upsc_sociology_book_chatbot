FROM python:3.12.11-slim

WORKDIR /app

# Copy requirements first to leverage Docker layer caching.
# This layer is only rebuilt if requirements.txt changes.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Now copy the rest of the application code.
COPY . .

# Expose the port the app runs on.
EXPOSE 8080

# Use a production-grade WSGI server like Gunicorn instead of Flask's dev server.
# You will need to add 'gunicorn' to your requirements.txt file.
# Environment variables should be passed in when running the container.
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]

