import 'package:flutter/material.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        LayoutBuilder(builder: (context, constraints) {
          final wide = constraints.maxWidth > 700;
          final profile = Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(colors: [Color(0xFF18766A), Color(0xFF245B51)]),
            ),
            child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(radius: 58, backgroundColor: Colors.white, child: CircleAvatar(radius: 54, backgroundImage: AssetImage('assets/images/danny.jpeg'))),
              SizedBox(height: 14),
              Text('Danny Luanda', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              SizedBox(height: 8),
              Text('Informaticien spécialisé en gestion des entreprises', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFEED2A8), fontWeight: FontWeight.w700)),
            ]),
          );
          const summary = Card(
            child: Padding(padding: EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('À propos', style: TextStyle(fontSize: 13, color: Color(0xFF18766A), fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              SizedBox(height: 10),
              Text('Un profil orienté vers la rigueur', style: TextStyle(fontSize: 24, height: 1.15, fontWeight: FontWeight.w900)),
              SizedBox(height: 12),
              Text("Titulaire d’un diplôme en informatique appliquée à la gestion des entreprises, je suis organisé, méthodique et à l’aise avec les outils numériques. Je souhaite mettre mes connaissances en gestion, en bureautique et en organisation au service d’une équipe logistique.", style: TextStyle(height: 1.6, color: Color(0xFF52635D))),
            ])),
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 300, child: profile), const SizedBox(width: 12), const Expanded(child: summary)])
              : Column(children: [profile, const SizedBox(height: 12), summary]);
        }),
        const SizedBox(height: 12),
        const CvSection(title: 'Formation', icon: Icons.school_outlined, children: [
          TimelineTile(year: '2025', title: 'ISIG Goma', subtitle: 'Informatique appliquée à la gestion des entreprises', detail: 'Approfondissement de la gestion, de l’informatique, des bases de données et de l’organisation.'),
          TimelineTile(year: '2022', title: 'Lycée Annuarite', subtitle: 'Humanités — option Électronique', detail: 'Formation secondaire technique orientée vers les sciences électroniques.'),
          TimelineTile(year: '2018', title: 'EP Sabyinyo', subtitle: 'Études primaires', detail: 'Parcours du cycle primaire.'),
        ]),
        const CvSection(title: 'Expériences', icon: Icons.work_outline_rounded, children: [
          TimelineTile(year: 'Stage', title: 'Assistant logistique', subtitle: 'Gestion opérationnelle', detail: 'Suivi des stocks, inventaires, préparation des commandes, classement des documents et rapports Excel.'),
          TimelineTile(year: 'Expérience', title: 'Assistant administratif', subtitle: 'Appui administratif', detail: 'Saisie de données, gestion documentaire, accueil et coordination des activités.'),
          TimelineTile(year: 'Projets', title: 'Développement informatique', subtitle: 'Applications web, desktop et mobiles', detail: 'Conception de solutions informatiques et manipulation des bases de données.'),
        ]),
        const CvSection(title: 'Compétences', icon: Icons.auto_awesome_outlined, children: [
          SkillChips(skills: ['Excel avancé', 'Word', 'PowerPoint', 'Bases de données', 'Programmation Web', 'Programmation Desktop', 'Programmation Mobile', 'Gestion des stocks', 'Inventaires', 'Organisation', 'Rigueur', 'Travail en équipe']),
        ]),
        const CvSection(title: 'Langues', icon: Icons.translate_rounded, children: [
          SkillChips(skills: ['Français', 'Anglais', 'Swahili']),
        ]),
        const CvSection(title: 'Domaines recherchés', icon: Icons.track_changes_rounded, children: [
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
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFE5F1EC), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: const Color(0xFF18766A))),
            const SizedBox(width: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ]),
          const SizedBox(height: 16),
          ...children,
        ]),
      ),
    );
  }
}

class TimelineTile extends StatelessWidget {
  final String year, title, subtitle, detail;
  const TimelineTile({super.key, required this.year, required this.title, required this.subtitle, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF7F9F5), borderRadius: BorderRadius.circular(16)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 72, child: Text(year, style: const TextStyle(color: Color(0xFF18766A), fontWeight: FontWeight.w900))),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(color: Color(0xFFB47732), fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(detail, style: const TextStyle(color: Color(0xFF52635D), height: 1.45)),
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
    return Wrap(spacing: 8, runSpacing: 8, children: skills.map((skill) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFFE5F1EC), borderRadius: BorderRadius.circular(999)),
      child: Text(skill, style: const TextStyle(color: Color(0xFF245B51), fontWeight: FontWeight.w800, fontSize: 13)),
    )).toList());
  }
}
