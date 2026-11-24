import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const CvApp());

class CvApp extends StatelessWidget {
  const CvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV MALI NDUHIRA Olivier',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5C6BC0), Color(0xFF283593), Color(0xFF10164A)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CircleAvatar(
                          radius: 42,
                          backgroundColor: Color(0xFFE8EAF6),
                          backgroundImage: AssetImage('assets/images/olivier.jpg'),
                        ),
                        const SizedBox(height: 16),
                        Text('Bienvenue', textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Connectez-vous à votre espace CV', textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _username,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Identifiant', prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Saisissez votre identifiant';
                            if (v.trim().toLowerCase() != 'olivier') return 'Identifiant incorrect';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _login(),
                          decoration: InputDecoration(
                            labelText: 'Mot de passe', prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Saisissez votre mot de passe';
                            if (v != '12345') return 'Mot de passe incorrect';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _login,
                          icon: const Icon(Icons.login_rounded),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text('Se connecter'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle TextThemeM(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium!;

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final _pages = const [CvPage(), FamilyPage(), ContactPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['Mon CV', 'Ma famille', 'Contact'][_index]),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (_) => false,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF3949AB)),
                accountName: Text('MALI NDUHIRA Olivier'),
                accountEmail: Text('Informatique · Logistique'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/olivier.jpg'),
                ),
              ),
              for (var i = 0; i < 3; i++)
                ListTile(
                  leading: Icon([Icons.badge_outlined, Icons.family_restroom, Icons.contact_mail_outlined][i]),
                  title: Text(['Accueil / CV', 'Famille', 'Contact'][i]),
                  selected: _index == i,
                  onTap: () {
                    setState(() => _index = i);
                    Navigator.pop(context);
                  },
                ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Se déconnecter'),
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (v) => setState(() => _index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.badge_outlined), selectedIcon: Icon(Icons.badge), label: 'CV'),
          NavigationDestination(icon: Icon(Icons.family_restroom_outlined), selectedIcon: Icon(Icons.family_restroom), label: 'Famille'),
          NavigationDestination(icon: Icon(Icons.contact_mail_outlined), selectedIcon: Icon(Icons.contact_mail), label: 'Contact'),
        ],
      ),
    );
  }
}

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
              final intro = const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Diplômé en informatique appliquée à la gestion des entreprises, rigoureux, organisé et doté d’une bonne maîtrise des outils numériques. Je souhaite mettre mes compétences en gestion, bureautique et organisation au service d’un poste en logistique."),
              ]);
              return wide
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 210, child: profile), const SizedBox(width: 24), Expanded(child: intro)])
                  : Column(children: [profile, const SizedBox(height: 18), intro]);
            }),
          ),
        ),
        const SizedBox(height: 12),
        const CvSection(title: 'Formation', icon: Icons.school_outlined, children: [
          TimelineTile(title: 'ISIG Goma', subtitle: 'Informatique appliquée à la gestion des entreprises · Fin 2025', detail: 'Diplôme universitaire dans les domaines de la gestion, de l’informatique, des bases de données et de l’organisation.'),
          TimelineTile(title: 'Lycée Annuarite', subtitle: 'Humanités, option Électronique · 2022', detail: 'Formation secondaire technique orientée vers l’électronique.'),
          TimelineTile(title: 'EP Sabyinyo', subtitle: 'Études primaires · 2018', detail: 'Cycle primaire.'),
        ]),
        const CvSection(title: 'Expérience professionnelle', icon: Icons.work_outline, children: [
          TimelineTile(title: 'Assistant logistique', subtitle: 'Stage académique', detail: 'Suivi des stocks, inventaires, préparation des commandes, classement des documents et rapports Excel.'),
          TimelineTile(title: 'Assistant administratif', subtitle: 'Expérience professionnelle', detail: 'Saisie de données, gestion documentaire, accueil et coordination des activités.'),
          TimelineTile(title: 'Projets informatiques', subtitle: 'Bases de données et développement', detail: 'Réalisation d’applications web, desktop et mobiles.'),
        ]),
        const CvSection(title: 'Compétences', icon: Icons.code_rounded, children: [
          SkillChips(skills: ['Excel avancé', 'Word', 'PowerPoint', 'Bases de données', 'Programmation Web', 'Programmation Desktop', 'Programmation Mobile', 'Gestion des stocks', 'Inventaires', 'Rapports', 'Organisation', 'Rigueur', 'Travail en équipe']),
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
      label: Text(s),
      side: BorderSide.none,
      backgroundColor: const Color(0xFFE8EAF6),
      labelStyle: const TextStyle(color: Color(0xFF283593), fontWeight: FontWeight.w600),
    )).toList());
  }
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  static const members = [
    ('Evriste Martinez', 'Père', 'Profession à renseigner', 'assets/images/papa.jpeg'),
    ('Dorothee Martinez', 'Mère', 'Profession à renseigner', 'assets/images/maman.jpeg'),
    ('MALI NDUHIRA Olivier', 'Moi', 'Informaticien', 'assets/images/olivier.jpg'),
    ('Sandrine Martinez', 'Sœur', 'Profession à renseigner', 'assets/images/sandrine.jpeg'),
    ('Martinez', 'Frère', 'Profession à renseigner', 'assets/images/martinez.jpeg'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(padding: EdgeInsets.only(bottom: 12), child: Text('Les membres de ma famille',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        for (final member in members)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFFE8EAF6),
                backgroundImage: AssetImage(member.$4),
              ),
              title: Text(member.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text('${member.$2} · ${member.$3}')),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
      ],
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final contacts = <(IconData, String, String, String)>[
      (Icons.phone_outlined, 'Téléphone 1', '+243 972 495 306', 'tel:+243972495306'),
      (Icons.phone_outlined, 'Téléphone 2', '+243 973 612 241', 'tel:+243973612241'),
      (Icons.email_outlined, 'E-mail', 'Oliviernduhira@gmail.com', 'mailto:Oliviernduhira@gmail.com'),
      (Icons.location_on_outlined, 'Adresse', 'Quartier Kyeshero', 'https://maps.google.com/maps/search/?api=1&query=Kyeshero'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: const [
              CircleAvatar(radius: 42, backgroundColor: Color(0xFFE8EAF6),
                  child: Icon(Icons.alternate_email, size: 44, color: Color(0xFF3949AB))),
              SizedBox(height: 12),
              Text('Restons en contact', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('Disponible pour échanger sur mes projets et mes opportunités.', textAlign: TextAlign.center),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        for (final c in contacts)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: const Color(0xFFE8EAF6),
                  child: Icon(c.$1, color: const Color(0xFF3949AB))),
              title: Text(c.$2), subtitle: Text(c.$3),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => _launch(c.$4),
            ),
          ),
      ],
    );
  }
}
