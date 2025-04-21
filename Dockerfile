# Use an official Python runtime as a parent image
# Choose a version compatible with your dependencies (3.9 or 3.10 are good)
FROM python:3.10-slim

# Set environment variables
# Prevents Python from writing pyc files to disc (optional)
ENV PYTHONDONTWRITEBYTECODE 1
# Ensures Python output is sent straight to terminal (useful for logs)
ENV PYTHONUNBUFFERED 1

# Create a non-root user and switch to it (good practice)
RUN useradd -m appuser
USER appuser

# Set the working directory in the container
WORKDIR /app

# --- Dependency Installation ---
# Copy the requirements file first to leverage Docker cache
COPY --chown=appuser:appuser requirements.txt .

# Install PyTorch and its dependencies (CPU version explicitly)
# Adjust torch version if needed, this finds compatible pyg dependencies
RUN pip install --no-cache-dir torch==$(python -c "import torch; print(torch.__version__)") --index-url https://download.pytorch.org/whl/cpu && \
    pip install --no-cache-dir torch_scatter torch_sparse torch_geometric -f https://data.pyg.org/whl/torch-$(python -c 'import torch; print(torch.__version__)').html

# Install other dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# --- Application Code ---
# Copy the rest of your application code into the working directory
# Ensure all necessary files/folders (app.py, templates, etc.) are copied
COPY --chown=appuser:appuser ./app.py .
COPY --chown=appuser:appuser ./templates ./templates/
# If you have other .py files or data directories needed at runtime (that aren't downloaded), copy them too
# e.g., COPY --chown=appuser:appuser ./utils.py .
# e.g., COPY --chown=appuser:appuser ./static ./static/

# --- Runtime Configuration ---
# Expose the port the app runs on (Hugging Face expects 7860 for web apps)
EXPOSE 7860

# Define the command to run your application using Gunicorn
# app:app refers to the 'app' variable in your 'app.py' file
# Use 0.0.0.0 to bind to all network interfaces within the container
CMD ["gunicorn", "--bind", "0.0.0.0:7860", "--workers=2", "app:app"]
