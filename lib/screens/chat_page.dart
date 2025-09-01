import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../localization/app_localizations.dart';

class ChatPage extends StatefulWidget {
  final String characterName;
  const ChatPage({super.key, required this.characterName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool _isSending = false;
  int _messageCount = 0;
  String _plan = 'Free';
  bool _limitReached = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
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
    } catch (_) {
      // ignore errors; default plan stays
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;
    if (_plan == 'Free' && _messageCount >= 5) {
      setState(() {
        _limitReached = true;
      });
      _showLimitWarning();
      return;
    }
    setState(() {
      _isSending = true;
      _messages.add({'from': 'user', 'text': text});
      _controller.clear();
      _messageCount++;
    });
    try {
      final token = await storage.read(key: 'arkadasai.token');
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/chat/send'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'message': text, 'persona': widget.characterName}),
      );
      String reply;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        reply = data['reply'] ?? '...';
      } else {
        reply = '...';
      }
      // simulate typing delay
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _messages.add({'from': 'assistant', 'text': reply});
        _isSending = false;
      });
    } catch (_) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _messages.add({'from': 'assistant', 'text': 'Yanıt alınamadı'});
        _isSending = false;
      });
    }
  }

  void _showLimitWarning() {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(loc.translate('limit_exceeded_title')),
          content: Text(loc.translate('limit_exceeded_message')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.characterName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isSending ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isSending && index == _messages.length) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('...'),
                    ),
                  );
                }
                final message = _messages[index];
                final isUser = message['from'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              },
            ),
          ),
          if (_plan != 'Free')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('TTS'),
                          content: const Text('Sesli okuma özelliği yakında.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Tamam'),
                            )
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.volume_up),
                  ),
                  if (kIsWeb)
                    IconButton(
                      onPressed: () {
                        // NSFW continues in web version
                      },
                      icon: const Icon(Icons.explicit),
                    ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
              child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).translate('type_message_hint'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _send,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
          if (_plan == 'Free')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('Kalan mesaj hakkı: ${5 - _messageCount}', style: Theme.of(context).textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}
