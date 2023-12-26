from flask import (
    flash, redirect, render_template, request, session, url_for
)
from MyExp4 import app
from MyExp4.database import db_session


@app.route('/admin/register', methods=('GET', 'POST'))
def register():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        password = request.form["password"]
        db = db_session()
        error = None

        if not email:
            error = 'Email address is required.'
        elif not password:
            error = 'Please enter the password.'

        if error is None:
            try:
                from MyExp4.crud import CustomerInsert
                db.execute(
                    "INSERT INTO customer_form (name, email) VALUES (?, ?)",
                    (name, email),
                )
                db.commit()
            except db.IntegrityError:
                error = f"User {name} is already registered."
            else:
                return redirect(url_for("admin.login"))

        flash(error)

    return render_template('admin/register.html')


@app.route('/admin/login')
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form["password"]
        db = db_session()
        error = None

        if not email:
            error = 'Email address is required.'
        elif not password:
            error = 'Please enter the password.'

        user = db.execute(
            'SELECT * FROM customer_form WHERE email = ?', email
        ).fetchone()

        if user is None or not user['email'] == email:
            error = 'Invalid user!'

        if error is None:
            # store information in a new session and return to the index
            db_session.clear()
            db_session['customer_number'] = user['customer_number']
            db_session['name'] = user['name']
            db_session['email'] = user['email']
            print('here')
            return redirect(url_for('home'))

        flash(error)

    return render_template('admin/login.html')


@app.route("/logout")
def logout():
    """Clear the current session, including the stored user id."""
    db_session.clear()
    return redirect(url_for("admin.login"))
