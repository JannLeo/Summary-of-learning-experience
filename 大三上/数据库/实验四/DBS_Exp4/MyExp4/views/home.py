from flask import render_template

from MyExp4 import app
from MyExp4.database import db_session, engine
from MyExp4.models import CouponsForm, CustomerForm, Sign


@app.route('/home')
def home():
    return render_template('home.html', Coupons=db_session.execute("SELECT * FROM coupons_form").all())
    # return render_template('home.html', Coupons=db_session.query(CouponsForm).all())