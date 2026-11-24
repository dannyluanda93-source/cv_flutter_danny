import 'package:flutter/material.dart';

import '../services/api_service.dart';

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  List<dynamic> _members = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final members = await ApiService.getFamille();
      if (!mounted) return;
      setState(() { _members = members; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _openForm({Map<String, dynamic>? member}) async {
    final nom = TextEditingController(text: member?['nom']?.toString() ?? '');
    final lien = TextEditingController(text: member?['lien']?.toString() ?? '');
    final profession = TextEditingController(text: member?['profession']?.toString() ?? '');
    final photo = TextEditingController(text: member?['photo_url']?.toString() ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(member == null ? 'Ajouter un membre' : 'Modifier le membre'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nom, decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: lien, decoration: const InputDecoration(labelText: 'Lien de parenté', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: profession, decoration: const InputDecoration(labelText: 'Profession', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: photo, decoration: const InputDecoration(labelText: 'URL de la photo', border: OutlineInputBorder())),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Enregistrer')),
        ],
      ),
    );

    if (saved != true) return;
    if (nom.text.trim().isEmpty || lien.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nom et lien sont obligatoires')));
      return;
    }

    final data = {
      'nom': nom.text.trim(),
      'lien': lien.text.trim(),
      'profession': profession.text.trim(),
      'photo_url': photo.text.trim().isEmpty ? null : photo.text.trim(),
    };

    try {
      if (member == null) {
        await ApiService.addFamille(data);
      } else {
        await ApiService.updateFamille(member['id'] as int, data);
      }
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _delete(Map<String, dynamic> member) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: Text('Supprimer ${member['nom']} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await ApiService.deleteFamille(member['id'] as int);
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(_error!, textAlign: TextAlign.center)));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Ajouter'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(padding: EdgeInsets.only(bottom: 12), child: Text('Les membres de ma famille',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            if (_members.isEmpty)
              const Card(child: Padding(padding: EdgeInsets.all(24), child: Text('Aucun membre enregistré.', textAlign: TextAlign.center))),
            for (final item in _members)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFFE8EAF6),
                    backgroundImage: item['photo_url']?.toString().isNotEmpty == true
                        ? NetworkImage(item['photo_url'].toString())
                        : null,
                    child: item['photo_url']?.toString().isNotEmpty != true
                        ? Text(item['nom'].toString()[0].toUpperCase())
                        : null,
                  ),
                  title: Text(item['nom'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${item['lien']} · ${item['profession'] ?? ''}'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _openForm(member: item as Map<String, dynamic>)),
                    IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _delete(item as Map<String, dynamic>)),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
