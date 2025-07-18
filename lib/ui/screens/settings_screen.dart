import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../core/models/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Widget buildArrow(BuildContext context) =>
      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final mainColor = settings.mainColor;

    return ListView(
      children: [
        ListTile(
          title: const Text('Тёмная тема'),
          trailing: Switch(
            value: settings.useSystemTheme,
            activeColor: mainColor,
            onChanged: (val) => settings.setUseSystemTheme(val),
          ),
        ),
        const Divider(height: 1),

        ListTile(
          title: const Text('Основной цвет'),
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
                  title: const Text('Выберите цвет'),
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
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('ОК'),
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
          title: const Text('Звуки'),
          trailing: buildArrow(context),
          onTap: () {},
        ),
        const Divider(height: 1),

        ListTile(
          title: const Text('Хаптики'),
          trailing: buildArrow(context),
          onTap: () {},
        ),
        const Divider(height: 1),

        ListTile(
          title: const Text('Код пароль'),
          trailing: buildArrow(context),
          onTap: () {},
        ),
        const Divider(height: 1),

        ListTile(
          title: const Text('Синхронизация'),
          trailing: buildArrow(context),
          onTap: () {},
        ),
        const Divider(height: 1),

        ListTile(
          title: const Text('Язык'),
          trailing: buildArrow(context),
          onTap: () {},
        ),
        const Divider(height: 1),

        ListTile(
          title: const Text('О программе'),
          trailing: buildArrow(context),
          onTap: () {},
        ),
        const Divider(height: 1),
        const SizedBox(height: 8),
      ],
    );
  }
}
