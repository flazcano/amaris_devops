FROM python:3.9.1-buster
ENV FLASK_DEBUG=1
ENV FLASK_APP app.py

COPY ./app.py /app/app.py
COPY requirements.txt .
RUN pip install -r requirements.txt
WORKDIR /app

ENTRYPOINT ["flask"]
CMD ["run", "--host=0.0.0.0", "--port=80"]
EXPOSE 80
