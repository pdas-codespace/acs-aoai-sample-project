FROM python:3.9-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Make the startup script executable
RUN chmod +x startup.sh

# Expose the port
EXPOSE 5000

# Set environment variables
ENV PORT=5000

# Start the application using gunicorn
CMD ["./startup.sh"]