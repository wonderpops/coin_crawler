import sqlalchemy
import databases
import os

engine = sqlalchemy.create_engine(f"postgresql+psycopg2://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@db/{os.environ['POSTGRES_DB']}")
database = databases.Database(f"postgresql+psycopg2://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@db/{os.environ['POSTGRES_DB']}")
metadata = sqlalchemy.MetaData()
metadata.create_all(engine)