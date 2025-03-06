import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Настройки")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text("Темная тема"),
            trailing: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                bool isDarkMode =
                    state is ThemeUpdated ? state.isDarkMode : false;
                return Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    context.read<ThemeBloc>().add(ToggleTheme(value));
                  },
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Политика конфиденциальности"),
            onTap: () {
              // TODO: Добавить переход на страницу политики
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Условия использования"),
            onTap: () {
              // TODO: Добавить переход на страницу условий
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Поддержка"),
            onTap: () {
              // TODO: Открыть поддержку (email, чат и т. д.)
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.share),
            title: Text("Поделиться приложением"),
            onTap: () {
              // TODO: Реализовать функционал шаринга
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("О приложении"),
            subtitle: Text("Версия 1.0.0"),
          ),
        ],
      ),
    );
  }
}
