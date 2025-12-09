import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Placeholder URLs - You can replace these with your actual Google Links
  final String form1Url = 'https://docs.google.com/forms/';
  final String form2Url = 'https://docs.google.com/forms/';
  final String sheet1Url = 'https://docs.google.com/spreadsheets/';
  final String sheet2Url = 'https://docs.google.com/spreadsheets/';

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Google Links'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Forms',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildLinkCard(
              context,
              title: 'Fill Form 1',
              icon: Icons.assignment,
              color: Colors.blue.shade100,
              onTap: () => _launchUrl(form1Url),
            ),
            const SizedBox(height: 10),
            _buildLinkCard(
              context,
              title: 'Fill Form 2',
              icon: Icons.assignment_outlined,
              color: Colors.blue.shade100,
              onTap: () => _launchUrl(form2Url),
            ),
            const SizedBox(height: 30),
            const Text(
              'Sheets',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildLinkCard(
              context,
              title: 'View Sheet 1',
              icon: Icons.table_chart,
              color: Colors.green.shade100,
              onTap: () => _launchUrl(sheet1Url),
            ),
            const SizedBox(height: 10),
            _buildLinkCard(
              context,
              title: 'View Sheet 2',
              icon: Icons.table_chart_outlined,
              color: Colors.green.shade100,
              onTap: () => _launchUrl(sheet2Url),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.black87),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
