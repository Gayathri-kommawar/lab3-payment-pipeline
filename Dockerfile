FROM python:3.12-alpine

WORKDIR /app

ARG BUILD_NUMBER
ARG GIT_COMMIT
ARG BRANCH_NAME

LABEL org.opencontainers.image.build="$BUILD_NUMBER"
LABEL org.opencontainers.image.revision="$GIT_COMMIT"
LABEL org.opencontainers.image.branch="$BRANCH_NAME"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY test_app.py .

EXPOSE 8080

CMD ["python", "app.py"]