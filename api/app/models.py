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