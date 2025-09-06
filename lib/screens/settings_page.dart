import 'package:flutter/material.dart';
import '../widgets/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Settings"),
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SettingsItem(title: "Account", subtitle: "Manage parent account"),
          SettingsItem(title: "Notifications", subtitle: "Enable/disable alerts"),
          SettingsItem(title: "Children", subtitle: "Manage child profiles"),
          SettingsItem(title: "Privacy", subtitle: "Parental controls"),
          SettingsItem(title: "Help & Support", subtitle: "Contact us"),
        ],
      ),
    );
  }
}
