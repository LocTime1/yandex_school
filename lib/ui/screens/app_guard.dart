import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/models/settings_provider.dart';
import '../../l10n/app_localizations.dart';
import 'pin_code_screen.dart';
import 'home_screen.dart';

class AppGuard extends StatefulWidget {
  const AppGuard({Key? key}) : super(key: key);

  @override
  State<AppGuard> createState() => _AppGuardState();
}

class _AppGuardState extends State<AppGuard> {
  bool _authPassed = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final settings = context.read<SettingsProvider>();
    await settings.load();
    final hasPin = await settings.hasPin();

    if (settings.biometricsEnabled) {
      final auth = LocalAuthentication();
      final canBio =
          await auth.canCheckBiometrics && await auth.isDeviceSupported();
      if (canBio) {
        final ok = await auth.authenticate(
          localizedReason: AppLocalizations.of(context)!.loginFaceId,
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (ok) {
          setState(() => _authPassed = true);
          return;
        }
      }
    }

    if (hasPin) {
      final ok = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => PinCodeScreen(isSetMode: false, canGoBack: false),
        ),
      );
      if (ok == true) {
        setState(() => _authPassed = true);
        return;
      }
    } else {
      setState(() => _authPassed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_authPassed) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return const HomeScreen();
  }
}
