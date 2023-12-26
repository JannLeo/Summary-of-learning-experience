"""
默认值，适用于所有的环境, 或交由具体环境进行覆盖。
例如，在config/default.py中设置DEBUG = False，在config/development.py中设置DEBUG = True
"""
DEBUG = False  # 启动Flask的Debug模式
SQLALCHEMY_ECHO = False
BCRYPT_LEVEL = 13  # 配置Flask-Bcrypt拓展


