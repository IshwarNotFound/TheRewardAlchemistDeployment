# Use an official Python runtime as a parent image
# Match the Python version you've been using (e.g., 3.9)
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /code

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies if any are needed (unlikely for this app)
# RUN apt-get update && apt-get install -y --no-install-recommends some-package && rm -rf /var/lib/apt/lists/*

# --- Dependency Installation ---

# Upgrade pip
RUN python -m pip install --upgrade pip

# Copy only requirements first to leverage Docker cache
COPY requirements.txt .

# Install packages from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install PyTorch CPU and PyTorch Geometric (adjust versions if needed)
# Use the versions you confirmed worked or intended to use
RUN pip install --no-cache-dir torch==1.13.1+cpu torchvision==0.14.1+cpu torchaudio==0.13.1 --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir torch_scatter torch_sparse torch_cluster torch_spline_`, `gunicorn`, `pandas`, `joblib`, `sentence-transformers`, `numpy<2.0`, etc., but **NOT** listing `torch` or `torch_geometric` packages).
*   Your `templates` folder with `index.html`.
*   This code should be committed and ideally pushed to your GitHub repo (though we'll push directly to the HF Space repo).
