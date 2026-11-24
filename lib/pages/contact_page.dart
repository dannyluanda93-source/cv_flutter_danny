import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launch(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
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
        const Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(children: [
              CircleAvatar(radius: 42, backgroundColor: Color(0xFFE8EAF6),
                  child: Icon(Icons.alternate_email, size: 44, color: Color(0xFF3949AB))),
              SizedBox(height: 12),
              Text('Restons en contact', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        for (final contact in contacts)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: const Color(0xFFE8EAF6),
                  child: Icon(contact.$1, color: const Color(0xFF3949AB))),
              title: Text(contact.$2), subtitle: Text(contact.$3),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => _launch(contact.$4),
            ),
          ),
      ],
    );
  }
}
