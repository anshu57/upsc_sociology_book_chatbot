# ---- Base Stage ----
# Use the official Python image as a parent image.
# Using a specific version is good practice for reproducibility.
FROM python:3.12-slim as base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# ---- Builder Stage ----
# This stage is for installing dependencies
FROM base as builder

# Install build dependencies if you have any that need compilation
# RUN apt-get update && apt-get install -y --no-install-recommends build-essential

# Copy the requirements file and install dependencies
# This is done in a separate layer to leverage Docker's caching mechanism.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- Final Stage ----
# This is the final image that will be run
FROM base as final

# Create a non-root user and group to run the application for better security
RUN addgroup --system app && adduser --system --group app

# Copy the installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

# Also copy the executables (like gunicorn) from the builder stage
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy the application code, changing ownership to the new user
COPY --chown=app:app . .

# Switch to the non-root user
USER app

# Command to run the application
# This example uses gunicorn, a common choice for production.
# The --workers flag is set to 4 as a sensible default for production.
# This allows Gunicorn to handle multiple requests concurrently.
# Adjust this value based on your EC2 instance's CPU cores.
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8000", "app:app"]