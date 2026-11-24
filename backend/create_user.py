import getpass

import bcrypt
import psycopg2

from config import DATABASE_URL


def main():
    email = input("E-mail [dannyluanda93@gmail.com]: ").strip()
    email = email or "dannyluanda93@gmail.com"

    password = getpass.getpass("Mot de passe: ")
    if not password:
        raise SystemExit("Le mot de passe ne peut pas être vide")

    confirmation = getpass.getpass("Confirmer le mot de passe: ")
    if password != confirmation:
        raise SystemExit("Les mots de passe ne correspondent pas")

    password_hash = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

    connection = psycopg2.connect(DATABASE_URL)
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO users (email, password_hash, nom, role)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT (email) DO UPDATE
                SET password_hash = EXCLUDED.password_hash,
                    nom = EXCLUDED.nom,
                    role = EXCLUDED.role
            """, (email.lower(), password_hash, "Danny Luanda", "admin"))
        connection.commit()
        print("Utilisateur créé ou mis à jour avec succès.")
    finally:
        connection.close()


if __name__ == "__main__":
    main()
