# Application CV — Danny Luanda

Application Flutter présentant le CV professionnel, les pages Famille et Contact, ainsi qu’un système de connexion sécurisé.

- **Projet GitHub :** https://github.com/dannyluanda93-source/cv_flutter_danny
- **Compte de démonstration :** `dannyluanda93@gmail.com`
- **Mot de passe :** `1234`

## TP1 — Application Flutter

Le premier travail pratique concerne principalement l’interface utilisateur et les fonctionnalités principales de l’application.

### Pages réalisées

- Formulaire de connexion.
- CV avec photo, profil, formation, expérience, compétences et langues.
- Page Famille permettant l’ajout, la modification et la suppression des membres.
- Page Contact avec téléphone, adresse e-mail et localisation.
- Menu de navigation mobile et menu latéral.
- Déconnexion de l’utilisateur.

### Technologies utilisées

- Flutter
- Dart
- Material 3
- SharedPreferences
- Package HTTP
- Package URL Launcher

### Captures du TP1

#### Page de connexion

![Page de connexion](screenshots/formulaire.png)

#### Page CV

![Page CV](screenshots/cv.png)

#### Page Famille

![Page Famille](screenshots/famille.png)

#### Page Contact

![Page Contact](screenshots/contact.png)

## TP2 — Base de données, backend et démonstration

Le deuxième travail pratique concerne l’API REST, l’authentification, PostgreSQL/Supabase et la démonstration complète.

### Base de données

La base utilisée est PostgreSQL, hébergée sur Supabase. Le script SQL se trouve dans :

```text
database/schema.sql
```

Il contient les tables suivantes :

- `users` : utilisateurs et mots de passe cryptés.
- `famille` : membres de famille.
- `cv_profils` : informations principales du CV.
- `formations` : parcours scolaire.
- `experiences` : expériences professionnelles.
- `competences` : compétences techniques et professionnelles.
- `langues` : langues parlées.
- `centres_interet` : domaines recherchés.
- `contacts` : coordonnées de contact.

### Configuration de Supabase

1. Ouvrir le projet Supabase.
2. Copier le contenu de `database/schema.sql` dans SQL Editor.
3. Exécuter le script.
4. Récupérer l’URL PostgreSQL depuis les paramètres du projet.
5. Copier `backend/.env.example` vers `backend/.env`.
6. Ajouter l’URL de la base et une clé secrète JWT dans `backend/.env`.

Le fichier `.env` ne doit pas être publié sur GitHub.

```text
DATABASE_URL=postgresql://UTILISATEUR:MOT_DE_PASSE@HOTE:5432/postgres
SECRET_KEY=VOTRE_CLE_SECRETE
```

### Backend Flask

Le backend REST se trouve dans le dossier `backend`.

```text
backend/
├── app.py
├── config.py
├── create_user.py
├── requirements.txt
└── .env.example
```

### API REST

| Méthode | Endpoint | Authentification | Fonction |
|---|---|---|---|
| POST | `/api/auth/login` | Non | Connexion avec e-mail et mot de passe |
| GET | `/api/famille` | JWT | Afficher les membres |
| POST | `/api/famille` | JWT | Ajouter un membre |
| PUT | `/api/famille/<id>` | JWT | Modifier un membre |
| DELETE | `/api/famille/<id>` | JWT | Supprimer un membre |
| GET | `/api/health` | Non | Vérifier que le serveur fonctionne |

L’authentification utilise JWT pour les échanges protégés et bcrypt pour le stockage sécurisé des mots de passe.

### Création de l’utilisateur avec `create_user.py`

Depuis le dossier racine :

```powershell
cd backend
python create_user.py
```

À l’invite :

- **E-mail :** `dannyluanda93@gmail.com`
- **Mot de passe :** `1234`
- **Confirmation :** `1234`

Le script crée l’utilisateur ou met à jour son mot de passe lorsqu’il existe déjà.

### Démarrer le backend

```powershell
cd backend
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python app.py
```

Le backend est accessible à l’adresse :

```text
http://127.0.0.1:5000
```

Test de disponibilité :

```text
http://127.0.0.1:5000/api/health
```

## Démarrer l’application complète

1. Configurer et démarrer Supabase.
2. Configurer `backend/.env`.
3. Créer l’utilisateur avec `backend/create_user.py`.
4. Démarrer Flask.
5. Depuis la racine du projet, lancer Flutter :

```powershell
flutter pub get
flutter run -d chrome
```

## Membres actuels de la famille

- Danny Luanda — Moi.
- Olive — Sœur.
- Fabrice — Frère.
- Grace — Sœur.

## Vidéo de démonstration — TP2

La vidéo doit montrer :

- Le démarrage du backend Flask.
- La connexion avec l’e-mail et le mot de passe.
- La consultation du CV.
- L’ajout, la modification et la suppression d’un membre.
- La connexion à Supabase et la consultation des données enregistrées.
- La déconnexion.

Lien de démonstration :

```text
LIEN_YOUTUBE_DE_LA_DEMONSTRATION
```

## Sécurité

- Les mots de passe ne sont pas stockés en clair dans la base.
- Les mots de passe sont hachés avec bcrypt.
- Les endpoints protégés exigent un token JWT.
- `backend/.env` est exclu du dépôt Git avec `.gitignore`.
- Une clé secrète différente doit être utilisée en production.
