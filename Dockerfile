FROM python:3.9-alpine3.13
LABEL maintainer="Ancel Miller"

# Set environment variables
# Prevents Python from writing pyc files to discarding them and buffering output, which is useful for logging
ENV PYTHONUNBUFFERED=1

# Install dependencies and create a non-root user to run the application
COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

 RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /tmp/requirements.txt \
    rm -rf /tmp \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Activate the virtual environment and set the PATH to use the virtual environment's Python and pip
# Note: In a Dockerfile, each RUN command is executed in a new shell, so we need to set the PATH environment variable to ensure that the virtual environment is used in subsequent commands.
ENV PATH="/venv/bin:$PATH"

# Switch to the non-root user to run the application
USER django-user
