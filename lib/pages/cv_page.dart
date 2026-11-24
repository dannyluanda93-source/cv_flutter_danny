import 'package:flutter/material.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(builder: (context, c) {
              final wide = c.maxWidth > 520;
              final profile = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(radius: 54, backgroundColor: Color(0xFFE8EAF6),
                      backgroundImage: AssetImage('assets/images/olivier.jpg')),
                  const SizedBox(height: 12),
                  Text('MALI NDUHIRA Olivier', textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Informaticien spécialisé en gestion des entreprises', textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF3949AB), fontWeight: FontWeight.w600)),
                ],
              );
              const intro = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Diplômé en informatique appliquée à la gestion des entreprises, rigoureux, organisé et doté d’une bonne maîtrise des outils numériques. Je souhaite mettre mes compétences en gestion, bureautique et organisation au service d’un poste en logistique."),
              ]);
              return wide
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 210, child: profile), const SizedBox(width: 24), const Expanded(child: intro)])
                  : Column(children: [profile, const SizedBox(height: 18), intro]);
            }),
          ),
        ),
        const SizedBox(height: 12),
        const CvSection(title: 'Formation', icon: Icons.school_outlined, children: [
          TimelineTile(title: 'ISIG Goma', subtitle: 'Informatique appliquée à la gestion des entreprises · Fin 2025', detail: 'Gestion, informatique, bases de données et organisation.'),
          TimelineTile(title: 'Lycée Annuarite', subtitle: 'Humanités, option Électronique · 2022', detail: 'Formation secondaire technique orientée vers l’électronique.'),
          TimelineTile(title: 'EP Sabyinyo', subtitle: 'Études primaires · 2018', detail: 'Cycle primaire.'),
        ]),
        const CvSection(title: 'Expérience professionnelle', icon: Icons.work_outline, children: [
          TimelineTile(title: 'Assistant logistique', subtitle: 'Stage académique', detail: 'Suivi des stocks, inventaires, préparation des commandes, classement des documents et rapports Excel.'),
          TimelineTile(title: 'Assistant administratif', subtitle: 'Expérience professionnelle', detail: 'Saisie de données, gestion documentaire, accueil et coordination des activités.'),
          TimelineTile(title: 'Projets informatiques', subtitle: 'Bases de données et développement', detail: 'Applications web, desktop et mobiles.'),
        ]),
        const CvSection(title: 'Compétences', icon: Icons.code_rounded, children: [
          SkillChips(skills: ['Excel avancé', 'Word', 'PowerPoint', 'Bases de données', 'Programmation Web', 'Programmation Desktop', 'Programmation Mobile', 'Gestion des stocks', 'Inventaires', 'Organisation', 'Rigueur', 'Travail en équipe']),
        ]),
        const CvSection(title: 'Langues', icon: Icons.language_rounded, children: [
          SkillChips(skills: ['Français', 'Anglais', 'Swahili']),
        ]),
        const CvSection(title: 'Objectif professionnel', icon: Icons.favorite_outline, children: [
          SkillChips(skills: ['Logistique', 'Gestion', 'Bureautique', 'Organisation']),
        ]),
      ],
    );
  }
}

class CvSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const CvSection({super.key, required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(icon, color: const Color(0xFF3949AB)), const SizedBox(width: 10),
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))]),
          const SizedBox(height: 12), ...children,
        ]),
      ),
    );
  }
}

class TimelineTile extends StatelessWidget {
  final String title, subtitle, detail;
  const TimelineTile({super.key, required this.title, required this.subtitle, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 7, right: 12), decoration: const BoxDecoration(color: Color(0xFF3949AB), shape: BoxShape.circle)),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 2), Text(subtitle, style: const TextStyle(color: Color(0xFF3949AB), fontWeight: FontWeight.w600)),
          const SizedBox(height: 5), Text(detail),
        ])),
      ]),
    );
  }
}

class SkillChips extends StatelessWidget {
  final List<String> skills;
  const SkillChips({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8, children: skills.map((s) => Chip(
      label: Text(s), side: BorderSide.none, backgroundColor: const Color(0xFFE8EAF6),
      labelStyle: const TextStyle(color: Color(0xFF283593), fontWeight: FontWeight.w600),
    )).toList());
  }
}
