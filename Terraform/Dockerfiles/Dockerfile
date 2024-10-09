# Dockerfile

FROM ubuntu:22.04

# Set the working directory
WORKDIR /opt/

# Copy the application code
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Install required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip python3-venv python3-dev build-essential \
    libxml2-dev libxslt1-dev libffi-dev libpq-dev libssl-dev zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create system user for the application
RUN adduser --system --group status-page

# Run the upgrade script
RUN bash /opt/status-page/upgrade.sh

# Expose the application port
EXPOSE 8000

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000", "--insecure"]

# Start the application using Gunicorn
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "statuspage.wsgi:application"]