# -*- coding: UTF-8 -*-
#
# Declaracion de modelos SQLAlchemy
# Juan Hernandez, 2013
#
import datetime
from sqlalchemy import create_engine, desc
from sqlalchemy import Column, Integer, String
from sqlalchemy import ForeignKey, Sequence, DateTime
from sqlalchemy import Boolean, Date, func, Text
from sqlalchemy.orm import relationship, backref
from sqlalchemy.orm import sessionmaker, scoped_session
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()


class User(Base):
    pass
