CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'user',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS famille (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    lien VARCHAR(100) NOT NULL,
    profession VARCHAR(255),
    photo_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS cv_profils (
    id BIGSERIAL PRIMARY KEY,
    nom_complet VARCHAR(255) NOT NULL,
    titre VARCHAR(255) NOT NULL,
    profil TEXT NOT NULL,
    photo_url TEXT
);

CREATE TABLE IF NOT EXISTS formations (
    id BIGSERIAL PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    sous_titre VARCHAR(255),
    detail TEXT,
    ordre INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS experiences (
    id BIGSERIAL PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    sous_titre VARCHAR(255),
    detail TEXT,
    ordre INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS competences (
    id BIGSERIAL PRIMARY KEY,
    categorie VARCHAR(100) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    ordre INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS langues (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    niveau VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS centres_interet (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS contacts (
    id BIGSERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    valeur VARCHAR(255) NOT NULL,
    url_action TEXT,
    ordre INTEGER NOT NULL DEFAULT 0
);

INSERT INTO cv_profils (nom_complet, titre, profil, photo_url)
VALUES (
    'Danny Luanda',
    'Informaticien spécialisé en gestion des entreprises',
    'Diplômé en informatique appliquée à la gestion des entreprises, rigoureux, organisé et doté d’une bonne maîtrise des outils numériques. Je souhaite mettre mes compétences en gestion, bureautique et organisation au service d’un poste en logistique.',
    'assets/images/danny.jpeg'
) ON CONFLICT DO NOTHING;

INSERT INTO formations (titre, sous_titre, detail, ordre)
SELECT 'ISIG Goma', 'Informatique appliquée à la gestion des entreprises · Fin 2025', 'Diplôme universitaire dans les domaines de la gestion, de l’informatique, des bases de données et de l’organisation.', 1
WHERE NOT EXISTS (SELECT 1 FROM formations WHERE titre = 'ISIG Goma');

INSERT INTO formations (titre, sous_titre, detail, ordre)
SELECT 'Lycée Annuarite', 'Humanités, option Électronique · 2022', 'Formation secondaire technique orientée vers l’électronique.', 2
WHERE NOT EXISTS (SELECT 1 FROM formations WHERE titre = 'Lycée Annuarite');

INSERT INTO formations (titre, sous_titre, detail, ordre)
SELECT 'EP Sabyinyo', 'Études primaires · 2018', 'Cycle primaire.', 3
WHERE NOT EXISTS (SELECT 1 FROM formations WHERE titre = 'EP Sabyinyo');

INSERT INTO experiences (titre, sous_titre, detail, ordre)
SELECT 'Assistant logistique', 'Stage académique', 'Suivi des stocks, inventaires, préparation des commandes, classement des documents et rapports Excel.', 1
WHERE NOT EXISTS (SELECT 1 FROM experiences WHERE titre = 'Assistant logistique');

INSERT INTO experiences (titre, sous_titre, detail, ordre)
SELECT 'Assistant administratif', 'Expérience professionnelle', 'Saisie de données, gestion documentaire, accueil et coordination des activités.', 2
WHERE NOT EXISTS (SELECT 1 FROM experiences WHERE titre = 'Assistant administratif');

INSERT INTO experiences (titre, sous_titre, detail, ordre)
SELECT 'Projets informatiques', 'Bases de données et développement', 'Réalisation d’applications web, desktop et mobiles.', 3
WHERE NOT EXISTS (SELECT 1 FROM experiences WHERE titre = 'Projets informatiques');

INSERT INTO competences (categorie, nom, ordre) VALUES
('Technique', 'Excel avancé', 1),
('Technique', 'Word', 2),
('Technique', 'PowerPoint', 3),
('Technique', 'Gestion des bases de données', 4),
('Technique', 'Programmation Web', 5),
('Technique', 'Programmation Desktop', 6),
('Technique', 'Programmation Mobile', 7),
('Technique', 'Gestion des stocks', 8),
('Technique', 'Inventaires', 9),
('Professionnelle', 'Organisation', 10),
('Professionnelle', 'Rigueur', 11),
('Professionnelle', 'Travail en équipe', 12)
ON CONFLICT DO NOTHING;

INSERT INTO langues (nom, niveau)
SELECT nom, niveau FROM (VALUES
    ('Français', 'Courant'),
    ('Anglais', 'Professionnel'),
    ('Swahili', 'Courant')
) AS donnees(nom, niveau)
WHERE NOT EXISTS (SELECT 1 FROM langues l WHERE l.nom = donnees.nom);

INSERT INTO centres_interet (nom)
SELECT nom FROM (VALUES
    ('Logistique'),
    ('Gestion'),
    ('Bureautique'),
    ('Organisation')
) AS donnees(nom)
WHERE NOT EXISTS (SELECT 1 FROM centres_interet c WHERE c.nom = donnees.nom);

INSERT INTO contacts (type, libelle, valeur, url_action, ordre) VALUES
('phone', 'Téléphone 1', '+243 972 495 306', 'tel:+243972495306', 1),
('phone', 'Téléphone 2', '+243 973 612 241', 'tel:+243973612241', 2),
('email', 'E-mail', 'dannyluanda93@gmail.com', 'mailto:dannyluanda93@gmail.com', 3),
('address', 'Adresse', 'Quartier Kyeshero', 'https://maps.google.com/maps/search/?api=1&query=Kyeshero', 4)
ON CONFLICT DO NOTHING;

DELETE FROM famille;
INSERT INTO famille (nom, lien, profession, photo_url) VALUES
('Danny Luanda', 'Moi', 'Informaticien', 'assets/images/danny.jpeg'),
('Olive', 'Sœur', 'Profession à renseigner', 'assets/images/olive.jpeg'),
('Fabrice', 'Frère', 'Profession à renseigner', 'assets/images/fabrice.jpeg'),
('Grace', 'Sœur', 'Profession à renseigner', 'assets/images/grace.jpeg');
