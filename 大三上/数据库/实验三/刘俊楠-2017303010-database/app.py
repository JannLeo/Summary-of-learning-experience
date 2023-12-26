from flask import Flask, render_template, request, flash, redirect, url_for

from sqlalchemy import Column, String, create_engine, Integer
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
import time
from sqlalchemy.testing import db

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///Sign.sqlite3'
app.config['SECRET_KEY'] = "random string"

# 创建对象的基类:
Base = declarative_base()

"""
如果数据库没有表,会帮你建好的
"""


# 定义User对象:
class Sign(Base):
    # 表的名字:
    __tablename__ = 'signupformtest'

    # 表的结构:
    customernumber = Column(String(30), primary_key=True, unique=True, nullable=False)
    signupnumber = Column(Integer, nullable=False)
    dealnumber = Column(Integer, nullable=False)

    # nation = Column(String(20), nullable=False)
    # birth = Column(String(8), nullable=False)
    # dealnumberess = Column(Text, nullable=False)
    # id_number = Column(String(18), nullable=False)
    # creater = Column(String(32))
    # create_time = Column(String(20), nullable=False)
    # updater = Column(String(32))
    # update_time = Column(String(20), nullable=False, default=time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()),
    #                      onupdate=time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
    # image_path = Column(String(200))
    # comment = Column(String(200))
    # def __init__(self, customernumber, signupnumber, dealnumber):
    #     self.customernumber = customernumber
    #     self.signupnumber = signupnumber
    #     self.dealnumber = dealnumber


# 初始化数据库连接:
engine = create_engine('postgresql+psycopg2://postgres:liujn@192.168.216.133:5432/postgres')  # 用户名:密码@localhost:端口/数据库名
# 创建DBSession类型:
DBSession = sessionmaker(bind=engine)
# 创建表
Base.metadata.create_all(engine)
session1 = DBSession()

"""
#插入操作
#创建会话
"""
# new_sign = Sign(customernumber=10,signupnumber=20,dealnumber=30)

new_sign = Sign()


def insert(customer, signup, deal):
    session = DBSession()
    # 创建新Sign对象:
    new_sign = Sign(customernumber=customer, signupnumber=signup, dealnumber=deal)
    # 添加到session:
    session.add(new_sign)
    # 提交即保存到数据库:
    session.commit()
    # 关闭session:
    session.close()


def searchdata(customer):
    # 查询操作
    # 创建Session
    session = DBSession()
    # 创建Query查询，filter是where条件，最后调用one()返回唯一行，如果调用all()则返回所有行:
    user = session.query(Sign).filter(Sign.customernumber == customer).one()
    if user:
        print('customernumber:', user.customernumber)
        print('signupnumber:', user.signupnumber)
        print('dealnumberess:', user.dealnumber)
    else:
        print("未找到指定结果！")
    session.close()  # 关闭Session


def changedata(customer, signup, deal):
    # # 更新操作
    session = DBSession()  # 创建会话
    users = session.query(Sign).filter_by(customernumber=customer).first()  # 查询条件
    users.signupnumber = signup  # 更新操作
    users.dealnumber = deal  # 更新操作
    session.add(users)  # 添加到会话
    session.commit()  # 提交即保存到数据库
    session.close()  # 关闭会话


def deletedata(customer):
    # 删除操作
    session = DBSession()  # 创建会话
    delete_users = session.query(Sign).filter(Sign.customernumber == customer).first()
    if delete_users:
        session.delete(delete_users)
        session.commit()
    session.close()  # 关闭会话


# @app.route('/')
# def hello_world():  # put application's code here
#     return 'Hello World!'

@app.route('/')
def show_all():
    return render_template('show_all.html', new_sign=session1.query(Sign).all())


@app.route('/new', methods=['GET', 'POST'])
def new():
    if request.method == 'POST':
        if not request.form['customernumber'] or not request.form['signupnumber'] \
                or not request.form['dealnumber']:
            flash('Please enter all the fields', 'error')
        else:
            insert(request.form['customernumber'], request.form['signupnumber'],
                   request.form['dealnumber'])
            flash('Record was successfully added!')
            return redirect(url_for('show_all'))
    return render_template('new.html')


@app.route('/change', methods=['GET', 'POST'])
def change():
    if request.method == 'POST':
        if not request.form['customernumber'] or not request.form['signupnumber'] \
                or not request.form['dealnumber']:
            flash('Please enter all the fields', 'error')
        else:
            changedata(request.form['customernumber'], request.form['signupnumber'],
                       request.form['dealnumber'])
            flash('Record was successfully changed!')
            return redirect(url_for('show_all'))
    return render_template('change.html')


@app.route('/delete', methods=['GET', 'POST'])
def delete():
    if request.method == 'POST':
        if not request.form['customernumber']:
            flash('Please enter all the fields', 'error')
        else:
            deletedata(request.form['customernumber'])
            flash('Record was successfully deleted!')
            return redirect(url_for('show_all'))
    return render_template('delete.html')


@app.route('/search', methods=['GET', 'POST'])
def search():
    if request.method == 'POST':
        if not request.form['customernumber']:
            flash('Please enter all the fields', 'error')
        else:
            user = session1.query(Sign).filter(Sign.customernumber ==
                                               request.form['customernumber']).one()
            if user:
                flash('Record was successfully searched!')
                return render_template('result.html', new_sign=session1.query(Sign).filter(
                    Sign.customernumber == request.form['customernumber']).all())
    return render_template('search.html')


if __name__ == '__main__':
    app.run()
