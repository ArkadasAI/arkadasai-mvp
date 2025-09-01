import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../localization/app_localizations.dart';
import 'chat_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final storage = const FlutterSecureStorage();
  String _plan = 'Free';

  final List<Map<String, dynamic>> _characters = [
    {'name': 'Sırdaş', 'locked': false},
    {'name': 'Mentor', 'locked': false},
    {'name': 'Koç', 'locked': false},
    {'name': 'Neşeli Dost', 'locked': false},
    {'name': 'Bilge', 'locked': false},
    {'name': 'Analist', 'locked': false},
    {'name': 'Flörtöz', 'locked': false},
    {'name': 'Eğitmen', 'locked': false},
    {'name': 'Yaratıcı', 'locked': false},
    {'name': 'Sevgili', 'locked': true},
  ];

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    try {
      final token = await storage.read(key: 'arkadasai.token');
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _plan = (data['user']?['plan'] ?? 'Free') as String;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('free_plan'))),
      body: ListView.builder(
        itemCount: _characters.length,
        itemBuilder: (context, index) {
          final char = _characters[index];
          final locked = char['locked'] as bool;
          final available = !locked || _plan == 'Pro';
          return ListTile(
            title: Text(char['name'] as String),
            trailing: locked
                ? Icon(
                    available ? Icons.lock_open : Icons.lock,
                    color: available ? Colors.green : Colors.red,
                  )
                : null,
            onTap: available
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(characterName: char['name'] as String),
                      ),
                    );
                  }
                : () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Kilitli'),
                        content: const Text('Bu karakter yalnızca Pro planda erişilebilir.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Tamam'),
                          )
                        ],
                      ),
                    );
                  },
          );
        },
      ),
    );
  }
}
