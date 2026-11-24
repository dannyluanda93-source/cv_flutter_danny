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
      (Icons.phone_outlined, 'Téléphone principal', '+243 972 495 306', 'tel:+243972495306'),
      (Icons.phone_outlined, 'Téléphone secondaire', '+243 973 612 241', 'tel:+243973612241'),
      (Icons.email_outlined, 'Adresse e-mail', 'dannyluanda93@gmail.com', 'mailto:dannyluanda93@gmail.com'),
      (Icons.location_on_outlined, 'Localisation', 'Quartier Kyeshero', 'https://maps.google.com/maps/search/?api=1&query=Kyeshero'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(colors: [Color(0xFF18766A), Color(0xFF245B51)]),
          ),
          child: const Row(children: [
            CircleAvatar(radius: 32, backgroundColor: Colors.white, child: Icon(Icons.alternate_email_rounded, size: 34, color: Color(0xFF18766A))),
            SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Restons en contact', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              SizedBox(height: 5),
              Text('Sélectionnez un moyen de communication.', style: TextStyle(color: Color(0xFFEED2A8))),
            ])),
          ]),
        ),
        const SizedBox(height: 12),
        for (final contact in contacts)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              leading: Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0xFFE5F1EC), borderRadius: BorderRadius.circular(14)), child: Icon(contact.$1, color: const Color(0xFF18766A))),
              title: Text(contact.$2, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(contact.$3, style: const TextStyle(color: Color(0xFF64746E)))),
              trailing: const Icon(Icons.north_east_rounded, size: 18, color: Color(0xFFB47732)),
              onTap: () => _launch(contact.$4),
            ),
          ),
      ],
    );
  }
}
