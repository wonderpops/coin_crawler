FROM python:3.8

WORKDIR /home
RUN apt-get update

# ENV TZ=Asia/Vladivostok
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN pip install --upgrade pip
RUN pip install uvicorn
RUN pip install fastapi
RUN pip install ormar
RUN pip install alembic
RUN pip install databases
RUN pip install aiosqlite
RUN pip install aiofiles
RUN pip install ffmpy
RUN pip install passlib[bcrypt]
RUN pip install python-multipart
RUN pip install fastapi-jwt-auth
RUN pip install psycopg2
RUN pip install asyncpg


EXPOSE 80

ADD ./ /api

WORKDIR /api

# CMD alembic revision --autogenerate && alembic upgrade head && python main.py
CMD python main.py