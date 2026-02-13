import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kappa/src/features/settings/domain/entities/settings_entity.dart';
import 'package:kappa/src/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:kappa/src/features/settings/presentation/bloc/settings_event.dart';
import 'package:kappa/src/features/settings/presentation/bloc/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            final AppSettingEntity settings = state.settings;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ListTile(
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: settings.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                            ThemeModeChanged(value ? ThemeMode.dark : ThemeMode.light),
                          );
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Language'),
                  trailing: DropdownButton<String>(
                    value: settings.languageCode,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        context.read<SettingsBloc>().add(LanguageChanged(newValue));
                      }
                    },
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'vi',
                        child: Text('Vietnamese'),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Receive Notifications'),
                  trailing: Switch(
                    value: settings.receiveNotifications,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(NotificationsToggled(value));
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Failed to load settings.'));
        },
      ),
    );
  }
}
