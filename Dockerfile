FROM python:3.6.2

#MAINTANER Your Name "marek.marzec@globallogic.com"


# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip3 install -r requirements.txt

COPY . /app

ENTRYPOINT ["python"]

CMD ["test_app.py"]

