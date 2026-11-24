import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'main_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final result = await ApiService.login(_email.text.trim(), _password.text);
      if (!mounted) return;
      if (result['token'] != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Identifiants incorrects. Veuillez réessayer.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de joindre le serveur.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
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
            colors: [Color(0xFFD9EFE7), Color(0xFFF7F8F3), Color(0xFFF1DEC4)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: LayoutBuilder(builder: (context, constraints) {
                  final wide = constraints.maxWidth > 700;
                  final intro = Container(
                    constraints: const BoxConstraints(minHeight: 520),
                    padding: const EdgeInsets.all(38),
                    decoration: BoxDecoration(
                      color: const Color(0xFF18766A),
                      borderRadius: BorderRadius.circular(32),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/danny.jpeg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Color(0x9918766A), BlendMode.srcATop),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('CURRICULUM VITAE', style: TextStyle(color: Color(0xFFEED2A8), fontWeight: FontWeight.w800, letterSpacing: 3)),
                        SizedBox(height: 12),
                        Text('Danny\nLuanda', style: TextStyle(color: Colors.white, fontSize: 38, height: 1.05, fontWeight: FontWeight.w900)),
                        SizedBox(height: 12),
                        Text('Gestion · Informatique · Organisation', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );

                  final form = Card(
                    elevation: 18,
                    shadowColor: const Color(0x3317352E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    child: Padding(
                      padding: EdgeInsets.all(wide ? 42 : 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(color: Color(0xFFE5F1EC), shape: BoxShape.circle),
                              child: const Icon(Icons.badge_outlined, color: Color(0xFF18766A), size: 32),
                            ),
                            const SizedBox(height: 20),
                            Text('Bon retour', style: Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 8),
                            const Text('Connectez-vous pour consulter mon parcours professionnel.', style: TextStyle(color: Color(0xFF64746E), height: 1.5)),
                            const SizedBox(height: 28),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(labelText: 'Adresse e-mail', prefixIcon: Icon(Icons.mail_outline_rounded)),
                              validator: (value) => value == null || value.trim().isEmpty ? 'Saisissez votre adresse e-mail' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _password,
                              obscureText: _obscure,
                              onFieldSubmitted: (_) => _login(),
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                ),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'Saisissez votre mot de passe' : null,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 54,
                              child: FilledButton.icon(
                                onPressed: _loading ? null : _login,
                                icon: _loading
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : const Icon(Icons.arrow_forward_rounded),
                                label: const Text('Se connecter'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  if (wide) {
                    return Row(children: [Expanded(child: intro), const SizedBox(width: 18), SizedBox(width: 390, child: form)]);
                  }
                  return Column(children: [intro, const SizedBox(height: 18), form]);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
