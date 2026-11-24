# CV Flutter — TP2

Application Flutter évoluée avec une API REST Flask, une authentification JWT/bcrypt et une base PostgreSQL Supabase.

## Architecture

```text
cv_flutter_olivier/
├── lib/
│   ├── main.dart
│   ├── services/api_service.dart
│   └── pages/
│       ├── login_page.dart
│       ├── famille_page.dart
│       ├── cv_page.dart
│       ├── contact_page.dart
│       └── main_navigation.dart
├── backend/
│   ├── app.py
│   ├── config.py
│   ├── create_user.py
│   └── requirements.txt
├── database/schema.sql
├── assets/images/
└── screenshots/
```

## Technologies

- Frontend : Flutter / Dart
- Backend : Python / Flask / Flask-CORS
- Base de données : PostgreSQL hébergée sur Supabase
- Authentification : JWT, bcrypt
- Flutter : http, shared_preferences

## Base de données Supabase

1. Créez un projet Supabase.
2. Ouvrez **SQL Editor**.
3. Copiez-collez intégralement `database/schema.sql` puis sélectionnez **Run**.
4. Depuis les paramètres du projet, récupérez la chaîne PostgreSQL.
5. Configurez `DATABASE_URL` dans `backend/config.py` ou dans un fichier `.env`.

Exemple :

```text
postgresql://postgres:MON_MOT_DE_PASSE@aws-0-eu-central-1.pooler.supabase.com:6543/postgres
```

## Identifiant de connexion

L’adresse e-mail est : `oliviernduhira@gmail.com`.

Le mot de passe n’est pas stocké dans Flutter. Il doit être créé dans Supabase avec :

```bash
cd backend
python create_user.py
```

Saisissez l’e-mail et le mot de passe lorsque le programme les demande.

## API REST

| Méthode | Endpoint | Authentification | Description |
|---|---|---|---|
| POST | `/api/auth/login` | Non | Vérifie l’e-mail et le mot de passe avec bcrypt |
| GET | `/api/famille` | JWT | Liste les membres |
| POST | `/api/famille` | JWT | Ajoute un membre |
| PUT | `/api/famille/<id>` | JWT | Modifie un membre |
| DELETE | `/api/famille/<id>` | JWT | Supprime un membre |
| GET | `/api/health` | Non | Vérifie que le serveur fonctionne |

La connexion envoie `Authorization: Bearer <token>`.
Le JWT est valide pendant 24 heures.

## Démarrer le backend

Depuis Windows :

```powershell
cd backend
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python app.py
```

Le backend écoute sur : `http://127.0.0.1:5000`.

Vérification :

```text
http://127.0.0.1:5000/api/health
```

## Démarrer le frontend

Depuis la racine du projet :

```powershell
flutter pub get
flutter run -d chrome
```

Au démarrage, Flutter vérifie le JWT enregistré dans `SharedPreferences`. Sans token valide, l’utilisateur reste sur la page de connexion.

## Captures d’écran

### Page de connexion

![Connexion](screenshots/formulaire.png)

### Page CV

![CV](screenshots/cv.png)

### Page Famille

![Famille](screenshots/famille.png)

### Page Contact

![Contact](screenshots/contact.png)

## Vidéo de démonstration

Insérez ici le lien YouTube de votre démonstration :

```text
https://www.youtube.com/watch?v=LIEN_DE_VOTRE_VIDEO
```

## Sécurité

- Aucun mot de passe permanent n’est écrit dans le code Flutter.
- Les mots de passe sont stockés sous forme de hash bcrypt.
- Les pages nécessitent un JWT valide.
- Remplacez `SECRET_KEY_TEST_A_REMPLACER` par une clé secrète forte en production.
