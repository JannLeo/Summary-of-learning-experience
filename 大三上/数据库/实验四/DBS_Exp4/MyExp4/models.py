from sqlalchemy import Column, String, Integer, Float, DateTime, Date, ForeignKey, func, Sequence
from sqlalchemy.orm import relationship

"""
如果数据库没有表,会帮你建好的
"""
from MyExp4.database import Base  # 导入对象的基类:

"""
如果数据库没有表,会帮你建好的
"""


# 定义User对象:
class CustomerForm(Base):
    # 表的名字:
    __tablename__ = 'customer_form'

    # 表的结构:
    customer_number = Column(String(30), primary_key=True, unique=True, nullable=False)
    name = Column(String(30), nullable=False)
    email = Column(String(30), nullable=False)


# 定义User对象:
class CouponsForm(Base):
    # 表的名字:
    __tablename__ = 'coupons_form'

    # 表的结构:
    deal_number = Column(Integer, primary_key=True, unique=True, nullable=False)
    description = Column(String(40), nullable=False)
    location = Column(String(15), nullable=False)
    deal_price = Column(Float, nullable=False)
    original_price = Column(Float, nullable=False)
    available_date = Column(Date, nullable=False)
    ending_date = Column(Date, nullable=False)


# 定义User对象:
class Sign(Base):
    # 表的名字:
    __tablename__ = 'sign_up_form'

    # 表的结构:
    sign_up_number = Column(Integer, primary_key=True, nullable=False)
    customer_number = Column(String(30), ForeignKey("customer_form.customer_number"))
    deal_number = Column(Integer, ForeignKey("coupons_form.deal_number"))


# 定义LogTable对象:
class LogTable(Base):
    # 表的名字:
    __tablename__ = 'log_table'

    # 表的结构:
    id_number = Column(Integer, Sequence('log_table_id_number'), primary_key=True, nullable=False)
    sign_up_number = Column(Integer)
    customer_number = Column(String(30))
    name = Column(String(30))
    email = Column(String(30))
    deal_number = Column(Integer)
    operation = Column(String(30))
    op_time = Column(DateTime)
    success = Column(String(30))
    description = Column(String(40))
    location = Column(String(15))
    deal_price = Column(Float)
    original_price = Column(Float)
    available_date = Column(Date)
    ending_date = Column(Date)


# 定义LogTable对象:
class Table_Audit(Base):
    # 表的名字:
    __tablename__ = 'table_audit'

    # 表的结构:
    deal_number = Column(Integer, Sequence('table_audit_deal_number'), primary_key=True)
    enable_number = Column(Integer)
    having_number = Column(Integer)
