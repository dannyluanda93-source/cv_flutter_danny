import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'contact_page.dart';
import 'cv_page.dart';
import 'famille_page.dart';
import 'login_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;
  final _pages = const [CvPage(), FamillePage(), ContactPage()];

  Future<void> _logout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['Curriculum vitae', 'Mon entourage', 'Coordonnées'][_index], style: const TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          IconButton(tooltip: 'Se déconnecter', onPressed: _logout, icon: const Icon(Icons.logout_rounded)),
          const SizedBox(width: 4),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFF7F8F3),
        child: SafeArea(
          child: Column(children: [
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF18766A), borderRadius: BorderRadius.circular(24)),
              child: const Row(children: [
                CircleAvatar(radius: 30, backgroundColor: Colors.white, child: CircleAvatar(radius: 27, backgroundImage: AssetImage('assets/images/danny.jpeg'))),
                SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Danny Luanda', maxLines: 2, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                  SizedBox(height: 4),
                  Text('dannyluanda93@gmail.com', style: TextStyle(color: Color(0xFFEED2A8), fontSize: 12)),
                ])),
              ]),
            ),
            for (var i = 0; i < 3; i++)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(color: _index == i ? const Color(0xFFE5F1EC) : null, borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: Icon([Icons.badge_outlined, Icons.family_restroom, Icons.contact_mail_outlined][i], color: _index == i ? const Color(0xFF18766A) : null),
                  title: Text(['Curriculum vitae', 'Famille', 'Contact'][i], style: TextStyle(fontWeight: _index == i ? FontWeight.w800 : FontWeight.w500)),
                  selected: _index == i,
                  onTap: () {
                    setState(() => _index = i);
                    Navigator.pop(context);
                  },
                ),
              ),
            const Spacer(),
            const Divider(height: 1),
            ListTile(leading: const Icon(Icons.logout_rounded), title: const Text('Se déconnecter'), onTap: _logout),
            const SizedBox(height: 8),
          ]),
        ),
      ),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 280), child: _pages[_index]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE7EBE5)))),
        child: NavigationBar(
          height: 72,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFE5F1EC),
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.badge_outlined), selectedIcon: Icon(Icons.badge, color: Color(0xFF18766A)), label: 'CV'),
            NavigationDestination(icon: Icon(Icons.family_restroom_outlined), selectedIcon: Icon(Icons.family_restroom, color: Color(0xFF18766A)), label: 'Famille'),
            NavigationDestination(icon: Icon(Icons.contact_mail_outlined), selectedIcon: Icon(Icons.contact_mail, color: Color(0xFF18766A)), label: 'Contact'),
          ],
        ),
      ),
    );
  }
}
