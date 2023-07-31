FROM python:3.8.10 as build-stage

RUN python -m venv /venv

COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip,id=auen-backend-cache \
   . /venv/bin/activate && pip install -r requirements.txt

FROM python:3.8.10-slim as final

WORKDIR /app

RUN apt update && \
  apt-get install -y libsndfile-dev ffmpeg lilypond

COPY --from=build-stage /venv /venv

COPY . .

CMD ["/venv/bin/uvicorn", "--host", "0.0.0.0", "--port", "8000", "app:app"]
