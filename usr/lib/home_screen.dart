import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Default placeholders - editable by the user in the app
  String form1Url = 'https://docs.google.com/forms/';
  String form2Url = 'https://docs.google.com/forms/';
  String sheet1Url = 'https://docs.google.com/spreadsheets/';
  String sheet2Url = 'https://docs.google.com/spreadsheets/';

  // Titles for the links
  String form1Title = 'Daily Report Form';
  String form2Title = 'Incident Log Form';
  String sheet1Title = 'Inventory Sheet';
  String sheet2Title = 'Employee Roster';

  Future<void> _launchUrl(String urlString, {bool isForm = false}) async {
    if (urlString.isEmpty || !urlString.startsWith('http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a valid URL first')),
      );
      _showEditDialog(
        isForm ? (urlString == form1Url ? 1 : 2) : (urlString == sheet1Url ? 3 : 4),
        isForm,
      );
      return;
    }

    final Uri url = Uri.parse(urlString);
    
    // Use inAppWebView for forms to keep user in the app
    // Use externalApplication for sheets to leverage the native Google Sheets app
    final LaunchMode mode = isForm 
        ? LaunchMode.inAppWebView 
        : LaunchMode.externalApplication;

    try {
      if (!await launchUrl(url, mode: mode)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching URL: $e')),
        );
      }
    }
  }

  Future<void> _showEditDialog(int index, bool isForm) async {
    String currentUrl = '';
    String currentTitle = '';
    
    switch (index) {
      case 1: currentUrl = form1Url; currentTitle = form1Title; break;
      case 2: currentUrl = form2Url; currentTitle = form2Title; break;
      case 3: currentUrl = sheet1Url; currentTitle = sheet1Title; break;
      case 4: currentUrl = sheet2Url; currentTitle = sheet2Title; break;
    }

    final TextEditingController urlController = TextEditingController(text: currentUrl);
    final TextEditingController titleController = TextEditingController(text: currentTitle);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${isForm ? "Form" : "Sheet"} Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Daily Report',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Google Link URL',
                hintText: 'https://docs.google.com/...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                switch (index) {
                  case 1: 
                    form1Url = urlController.text; 
                    form1Title = titleController.text;
                    break;
                  case 2: 
                    form2Url = urlController.text;
                    form2Title = titleController.text;
                    break;
                  case 3: 
                    sheet1Url = urlController.text;
                    sheet1Title = titleController.text;
                    break;
                  case 4: 
                    sheet2Url = urlController.text;
                    sheet2Title = titleController.text;
                    break;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to use'),
                  content: const Text('Tap the "Edit" button on any card to paste your specific Google Form or Sheet links.'),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeader('Form Filling', Icons.edit_document),
            const SizedBox(height: 10),
            _buildLinkCard(
              context,
              title: form1Title,
              subtitle: 'Tap to fill form',
              icon: Icons.assignment,
              color: Colors.blue.shade50,
              iconColor: Colors.blue.shade700,
              onTap: () => _launchUrl(form1Url, isForm: true),
              onEdit: () => _showEditDialog(1, true),
            ),
            const SizedBox(height: 12),
            _buildLinkCard(
              context,
              title: form2Title,
              subtitle: 'Tap to fill form',
              icon: Icons.assignment_outlined,
              color: Colors.blue.shade50,
              iconColor: Colors.blue.shade700,
              onTap: () => _launchUrl(form2Url, isForm: true),
              onEdit: () => _showEditDialog(2, true),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader('Data Sheets', Icons.table_view),
            const SizedBox(height: 10),
            _buildLinkCard(
              context,
              title: sheet1Title,
              subtitle: 'Tap to view data',
              icon: Icons.table_chart,
              color: Colors.green.shade50,
              iconColor: Colors.green.shade700,
              onTap: () => _launchUrl(sheet1Url, isForm: false),
              onEdit: () => _showEditDialog(3, false),
            ),
            const SizedBox(height: 12),
            _buildLinkCard(
              context,
              title: sheet2Title,
              subtitle: 'Tap to view data',
              icon: Icons.table_chart_outlined,
              color: Colors.green.shade50,
              iconColor: Colors.green.shade700,
              onTap: () => _launchUrl(sheet2Url, isForm: false),
              onEdit: () => _showEditDialog(4, false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkCard(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color color,
      required Color iconColor,
      required VoidCallback onTap,
      required VoidCallback onEdit}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: Colors.grey.shade600,
                onPressed: onEdit,
                tooltip: 'Edit Link',
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}
