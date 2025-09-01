import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../localization/app_localizations.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final storage = const FlutterSecureStorage();
  bool _loading = false;

  Future<void> _guestLogin() async {
    setState(() {
      _loading = true;
    });
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/auth/login');
    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': 'guest@arkadas.ai',
          'password': 'guest',
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await storage.write(key: 'arkadasai.token', value: token);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                // Google sign-in not implemented
              },
              child: const Text('Google'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // email register placeholder
              },
              child: const Text('Email / Register'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _guestLogin,
              child: _loading
                  ? const CircularProgressIndicator()
                  : Text(loc.translate('guest_login')),
            ),
          ],
        ),
      ),
    );
  }
}
