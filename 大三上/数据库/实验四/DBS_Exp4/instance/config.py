"""
根据开发环境配置的变量，覆盖根目录下config.py中的文件配置，可移除
"""
DEBUG = True
SQLALCHEMY_ECHO = True

"""
数据库安全性配置
"""
SECRET_KEY = 'wu79hvr4t4h3uyf8b'  # 复杂的任意值, Flask使用该值（作为密钥）来对cookies和别的东西进行签名
STRIPE_API_KEY = 'SmFjb2IgS2FwbGFuLU1vc3MgaXMgYSBoZXJv'

# 数据库连接，postgresql+psycopg2://用户名:密码@localhost:端口/数据库名
SQLALCHEMY_DATABASE_URI = "postgresql+psycopg2://liuyuwen_2018152068:123456@192.168.239.132:5432/exp4Test"

