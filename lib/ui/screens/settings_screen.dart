import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../core/models/settings_provider.dart';
import '../../l10n/app_localizations.dart';
import 'pin_code_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Widget buildArrow(BuildContext context) => Icon(
    Icons.arrow_forward_ios,
    size: 16,
    color: Theme.of(context).colorScheme.onSurface,
  );

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final mainColor = settings.mainColor;

    return ListView(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.darkTheme),
          trailing: Switch(
            value: settings.useSystemTheme,
            activeColor: mainColor,
            onChanged: (val) => settings.setUseSystemTheme(val),
          ),
        ),
        const Divider(height: 1),

        ListTile(
          title: Text(AppLocalizations.of(context)!.mainColor),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [CircleAvatar(backgroundColor: mainColor, radius: 10)],
          ),
          onTap: () async {
            Color pickedColor = settings.mainColor;
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.chooseColor),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: pickedColor,
                      onColorChanged: (color) {
                        pickedColor = color;
                      },
                      showLabel: false,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.ok),
                    ),
                  ],
                );
              },
            );
            if (pickedColor != settings.mainColor) {
              settings.setMainColor(pickedColor);
            }
          },
        ),
        const Divider(height: 1),

        ListTile(
          title: Text(AppLocalizations.of(context)!.sounds),
          trailing: buildArrow(context),
          onTap: () {},
        ),
        const Divider(height: 1),

        SwitchListTile(
          title: Text(AppLocalizations.of(context)!.haptics),
          value: settings.hapticsEnabled,
          activeColor: mainColor,
          onChanged: (val) => settings.setHapticsEnabled(val),
        ),
        const Divider(height: 1),

        ListTile(
          title: Text(AppLocalizations.of(context)!.pinCode),
          trailing: buildArrow(context),
          onTap: () async {
            final hasPin = await settings.hasPin();
            if (hasPin) {
              final ok = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder:
                      (_) => PinCodeScreen(
                        isSetMode: false,
                        promptText: AppLocalizations.of(context)!.oldPin,
                      ),
                ),
              );
              if (ok == true) {
                await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => PinCodeScreen(isSetMode: true),
                  ),
                );
              }
            } else {
              await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => PinCodeScreen(isSetMode: true),
                ),
              );
            }
          },
        ),
        const Divider(height: 1),

        SwitchListTile(
          title: Text(AppLocalizations.of(context)!.faceID),
          value: settings.biometricsEnabled,
          onChanged: (val) => settings.setBiometricsEnabled(val),
        ),
        const Divider(height: 1),

        ListTile(
          title: Text(AppLocalizations.of(context)!.sync),
          trailing: buildArrow(context),
          onTap: () {},
        ),
        const Divider(height: 1),

        ListTile(
          title: Text(AppLocalizations.of(context)!.settings),
          trailing: DropdownButton<Locale>(
            value: settings.selectedLocale ?? Locale('ru'),
            underline: SizedBox(),
            items: const [
              DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
              DropdownMenuItem(value: Locale('en'), child: Text('English')),
            ],
            onChanged: (locale) {
              if (locale != null) {
                settings.setLocale(locale);
              }
            },
          ),
        ),

        const Divider(height: 1),

        ListTile(
          title: Text(AppLocalizations.of(context)!.about),
          trailing: buildArrow(context),
          onTap: () {},
        ),
        const Divider(height: 1),
        const SizedBox(height: 8),
      ],
    );
  }
}
