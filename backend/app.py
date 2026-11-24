import datetime
from functools import wraps

import bcrypt
import jwt
import psycopg2
from psycopg2.extras import RealDictCursor
from flask import Flask, request, jsonify
from flask_cors import CORS

from config import DATABASE_URL, SECRET_KEY, JWT_EXPIRATION_HOURS

app = Flask(__name__)
CORS(app)


def get_db():
    return psycopg2.connect(DATABASE_URL, cursor_factory=RealDictCursor)


def token_required(view):
    @wraps(view)
    def decorated(*args, **kwargs):
        auth = request.headers.get("Authorization", "")
        if not auth.startswith("Bearer "):
            return jsonify({"error": "Token absent"}), 401

        token = auth.split(" ", 1)[1].strip()
        try:
            payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        except jwt.ExpiredSignatureError:
            return jsonify({"error": "Token expiré"}), 403
        except jwt.InvalidTokenError:
            return jsonify({"error": "Token invalide"}), 403

        return view(payload, *args, **kwargs)

    return decorated


@app.post("/api/auth/login")
def login():
    data = request.get_json(silent=True) or {}
    email = (data.get("email") or "").strip().lower()
    password = data.get("password") or ""

    if not email or not password:
        return jsonify({"error": "Email et mot de passe requis"}), 400

    connection = get_db()
    try:
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT id, email, password_hash, nom, role FROM users WHERE email = %s",
                (email,),
            )
            user = cursor.fetchone()
    except Exception as e:
        return jsonify({"error": "Service indisponible"}), 503
    finally:
        connection.close()

    if not user:
        return jsonify({"error": "Identifiants incorrects"}), 401

    if not bcrypt.checkpw(password.encode("utf-8"), user["password_hash"].encode("utf-8")):
        return jsonify({"error": "Identifiants incorrects"}), 401

    payload = {
        "sub": str(user["id"]),
        "email": user["email"],
        "role": user["role"],
        "exp": datetime.datetime.now(datetime.timezone.utc)
        + datetime.timedelta(hours=JWT_EXPIRATION_HOURS),
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")

    return jsonify({
        "token": token,
        "user": {
            "id": user["id"],
            "email": user["email"],
            "nom": user["nom"],
            "role": user["role"],
        },
    })


@app.get("/api/famille")
@token_required
def get_famille(payload):
    try:
        connection = get_db()
    except Exception:
        return jsonify({"error": "Service indisponible: base de données inaccessible"}), 503

    try:
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT id, nom, lien, profession, photo_url, created_at "
                "FROM famille ORDER BY id"
            )
            members = cursor.fetchall()
    finally:
        connection.close()

    return jsonify([dict(member) for member in members])


@app.post("/api/famille")
@token_required
def add_famille(payload):
    data = request.get_json(silent=True) or {}
    nom = (data.get("nom") or "").strip()
    lien = (data.get("lien") or "").strip()
    profession = (data.get("profession") or "").strip() or None
    photo_url = (data.get("photo_url") or "").strip() or None

    if not nom or not lien:
        return jsonify({"error": "Nom et lien sont obligatoires"}), 400

    connection = get_db()
    try:
        with connection.cursor() as cursor:
            cursor.execute(
                "INSERT INTO famille (nom, lien, profession, photo_url) "
                "VALUES (%s, %s, %s, %s) "
                "RETURNING id, nom, lien, profession, photo_url, created_at",
                (nom, lien, profession, photo_url),
            )
            member = cursor.fetchone()
        connection.commit()
    finally:
        connection.close()

    return jsonify(dict(member)), 201


@app.put("/api/famille/<int:member_id>")
@token_required
def update_famille(payload, member_id):
    data = request.get_json(silent=True) or {}
    nom = (data.get("nom") or "").strip()
    lien = (data.get("lien") or "").strip()
    profession = (data.get("profession") or "").strip() or None
    photo_url = (data.get("photo_url") or "").strip() or None

    if not nom or not lien:
        return jsonify({"error": "Nom et lien sont obligatoires"}), 400

    connection = get_db()
    try:
        with connection.cursor() as cursor:
            cursor.execute(
                "UPDATE famille SET nom=%s, lien=%s, profession=%s, photo_url=%s "
                "WHERE id=%s "
                "RETURNING id, nom, lien, profession, photo_url, created_at",
                (nom, lien, profession, photo_url, member_id),
            )
            member = cursor.fetchone()
        connection.commit()
    finally:
        connection.close()

    if not member:
        return jsonify({"error": "Membre introuvable"}), 404
    return jsonify(dict(member))


@app.delete("/api/famille/<int:member_id>")
@token_required
def delete_famille(payload, member_id):
    connection = get_db()
    try:
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM famille WHERE id=%s RETURNING id", (member_id,))
            deleted = cursor.fetchone()
        connection.commit()
    finally:
        connection.close()

    if not deleted:
        return jsonify({"error": "Membre introuvable"}), 404
    return jsonify({"message": "Membre supprimé", "id": member_id})


@app.get("/api/health")
def health():
    return jsonify({"status": "ok"})


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)
