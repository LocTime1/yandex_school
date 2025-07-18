import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/settings_provider.dart';

class PinCodeScreen extends StatefulWidget {
  final bool isSetMode;
  final String? promptText;
  final bool canGoBack;

  const PinCodeScreen({
    Key? key,
    required this.isSetMode,
    this.promptText,
    this.canGoBack = true,
  }) : super(key: key);

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final _controller = TextEditingController();
  String _error = '';
  bool _isLoading = false;

  void _submit() async {
    if (_controller.text.length != 4) return;
    setState(() => _isLoading = true);
    final settings = context.read<SettingsProvider>();

    if (widget.isSetMode) {
      await settings.setPin(_controller.text);
      if (mounted) Navigator.of(context).pop(true);
    } else {
      final pin = await settings.getPin();
      if (_controller.text == pin) {
        if (mounted) Navigator.of(context).pop(true);
      } else {
        setState(() {
          _error = 'Неверный пин-код';
          _controller.clear();
        });
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    String prompt =
        widget.promptText ??
        (widget.isSetMode
            ? 'Задайте новый 4-значный код'
            : 'Введите 4-значный код');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSetMode ? 'Установить PIN' : 'Введите PIN'),
        centerTitle: true,
        automaticallyImplyLeading: widget.canGoBack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(prompt),
            const SizedBox(height: 32),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, letterSpacing: 16),
              onChanged: (s) {
                if (s.length == 4) _submit();
              },
              decoration: InputDecoration(
                counterText: '',
                errorText: _error.isEmpty ? null : _error,
                border: const OutlineInputBorder(),
              ),
            ),
            if (_isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
