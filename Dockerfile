FROM python:3.9

WORKDIR /app



COPY MYSQL_Query /docker-quaries


COPY FlaskApp .

COPY . .

RUN pip install --no-cache-dir -r requirements.txt


EXPOSE 5002


CMD ["python", "app.py"]

