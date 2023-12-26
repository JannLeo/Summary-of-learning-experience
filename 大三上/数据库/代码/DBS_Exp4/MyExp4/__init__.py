from flask import Flask
app: Flask = Flask(__name__, instance_relative_config=True)  # 实例化,创建应用对象

'''
配置设置
'''
app.config.from_object('config.default')  # 一般配置
# 现在通过app.config["VAR_NAME"]，我们可以访问到对应的变量

# instance文件夹可以帮助我们隐藏不愿为人所知的配置变量，改变特定环境下的程序配置
app.config.from_pyfile('config.py')  # 从instance文件夹中加载配置

# 应对复杂的，基于环境的配置
# app.config.from_envvar('APP_CONFIG_FILE') # 加载由环境变量APP_CONFIG_FILE指定的文件。
# APP_CONFIG_FILE环境变量的值应该是一个配置文件的绝对路径。
# eg.在Linux服务器上使用shell脚本来设置环境变量并运行run.py
# start.sh:
#           APP_CONFIG_FILE=/var/www/yourapp/config/production.py


'''
数据库初始化
'''
from MyExp4.database import init_db
init_db()


"""
从表格导入原始数据（数据库端已完成）
copy coupons_form from '/mnt/hgfs/share/yuwen_CouponsForm.csv' csv header;
copy customer_form from '/mnt/hgfs/share/zhouqi_CustomerForm.csv' csv header;
copy sign_up_form from '/mnt/hgfs/share/junnan_SignUpForm.csv' csv header;
"""

import MyExp4.views
import views.admin
import views.home
import views.functions

app.run()














