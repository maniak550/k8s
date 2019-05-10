FROM python:3.6.2

#MAINTANER Your Name "marek.marzec@globallogic.com"


# We copy just the requirements.txt first to leverage Docker cache
COPY ./app /app/

WORKDIR /app/

RUN pip3 install -r requirements.txt

ENTRYPOINT ["python"]

CMD ["test_app.py"]

#CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
