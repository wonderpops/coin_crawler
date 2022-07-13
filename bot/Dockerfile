FROM python:3.8

WORKDIR /home
RUN apt-get update

# ENV TZ=Asia/Vladivostok
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN pip install --upgrade pip
RUN pip install binance-connector

ADD ./ /bot

WORKDIR /bot

CMD ["python", "-u", "main.py"]