from email.policy import default
import databases
import sqlalchemy
import pydantic
import datetime
from typing import List, Optional, Union, Dict, Text
from pydantic import BaseModel
from sqlalchemy import func, text

import ormar

from app.db import database, metadata


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: str


class User(ormar.Model):
    class Meta:
        tablename = "users"
        database = database
        metadata = metadata

    id: int = ormar.Integer(primary_key=True)
    username: str = ormar.String(max_length=200)
    email: str = ormar.String(max_length=200, nullable=True)
    disabled: bool = ormar.Boolean(nullable=True)
    hashed_password: str = ormar.String(max_length=200)


class Coin_pair(ormar.Model):
    class Meta:
        tablename = "Coin_pairs"
        database = database
        metadata = metadata

    id: int = ormar.Integer(primary_key=True)
    name: str = ormar.String(max_length=50)
    short_name: str = ormar.String(max_length=10)
    status: str = ormar.String(max_length=10)
    enabled: bool = ormar.Boolean(default=False)


class Coin_pair_data(ormar.Model):
    class Meta:
        tablename = "coin_pairs_data"
        database = database
        metadata = metadata

    id: int = ormar.Integer(primary_key=True)
    coin_pair: Coin_pair = ormar.ForeignKey(Coin_pair)
    open: float = ormar.Float()
    close: float = ormar.Float()
    high: float = ormar.Float()
    low: float = ormar.Float()
    k: float = ormar.Float()
    d: float = ormar.Float()
    open_time: datetime.datetime = ormar.DateTime()
    close_time: datetime.datetime = ormar.DateTime()