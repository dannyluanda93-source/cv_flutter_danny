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
        title: Text(['Mon CV', 'Ma famille', 'Contact'][_index]),
        centerTitle: true,
        actions: [
          IconButton(tooltip: 'Se déconnecter', onPressed: _logout,
              icon: const Icon(Icons.logout_rounded)),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF3949AB)),
              accountName: Text('MALI NDUHIRA Olivier'),
              accountEmail: Text('oliviernduhira@gmail.com'),
              currentAccountPicture: CircleAvatar(
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
            ListTile(leading: const Icon(Icons.logout), title: const Text('Se déconnecter'), onTap: _logout),
          ]),
        ),
      ),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: _pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.badge_outlined), selectedIcon: Icon(Icons.badge), label: 'CV'),
          NavigationDestination(icon: Icon(Icons.family_restroom_outlined), selectedIcon: Icon(Icons.family_restroom), label: 'Famille'),
          NavigationDestination(icon: Icon(Icons.contact_mail_outlined), selectedIcon: Icon(Icons.contact_mail), label: 'Contact'),
        ],
      ),
    );
  }
}
