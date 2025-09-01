import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import 'auth_page.dart';

class Onboarding2Page extends StatefulWidget {
  const Onboarding2Page({super.key});

  @override
  State<Onboarding2Page> createState() => _Onboarding2PageState();
}

class _Onboarding2PageState extends State<Onboarding2Page> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  DateTime? _dob;
  String? _gender;
  String? _preferredGender;
  String? _language;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 18),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: loc.translate('username'),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: loc.translate('date_of_birth'),
                  ),
                  child: Text(
                    _dob != null
                        ? '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}'
                        : '-',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(labelText: loc.translate('gender')),
                items: [
                  DropdownMenuItem(
                    value: 'woman',
                    child: Text(loc.translate('gender_woman')),
                  ),
                  DropdownMenuItem(
                    value: 'man',
                    child: Text(loc.translate('gender_man')),
                  ),
                  DropdownMenuItem(
                    value: 'unspecified',
                    child: Text(loc.translate('gender_unspecified')),
                  ),
                ],
                onChanged: (val) => setState(() => _gender = val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _preferredGender,
                decoration: InputDecoration(labelText: loc.translate('preferred_gender')),
                items: [
                  DropdownMenuItem(
                    value: 'woman',
                    child: Text(loc.translate('preferred_woman')),
                  ),
                  DropdownMenuItem(
                    value: 'man',
                    child: Text(loc.translate('preferred_man')),
                  ),
                  DropdownMenuItem(
                    value: 'both',
                    child: Text(loc.translate('preferred_both')),
                  ),
                ],
                onChanged: (val) => setState(() => _preferredGender = val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _language,
                decoration: InputDecoration(labelText: loc.translate('language')),
                items: const [
                  DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'ar', child: Text('العربية')),
                ],
                onChanged: (val) => setState(() => _language = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // next to auth
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthPage()),
                  );
                },
                child: Text(loc.translate('get_started')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
