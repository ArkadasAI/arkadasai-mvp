import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> _fetchProfile() async {
    final token = await storage.read(key: 'arkadasai.token');
    final response = await http.get(
      Uri.parse('${AppConfig.apiBaseUrl}/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load profile');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profil')),
            body: Center(child: Text('Profil yüklenemedi')),
          );
        }
        final profile = snapshot.data!;
        final user = profile['user'] as Map<String, dynamic>;
        return Scaffold(
          appBar: AppBar(title: const Text('Profil')),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${user['email']}'),
                Text('Plan: ${user['plan']}'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final response = await http.post(
                      Uri.parse('${AppConfig.apiBaseUrl}/purchase/confirm'),
                      headers: {
                        'Authorization': 'Bearer ${await storage.read(key: 'arkadasai.token')}',
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode({'plan': 'Plus'}),
                    );
                    if (response.statusCode == 200) {
                      setState(() {});
                    }
                  },
                  child: const Text('Yükselt (Plus)'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    await storage.delete(key: 'arkadasai.token');
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Çıkış'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
