import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ✅ Variables للتحكم في القيم
  bool darkMode = false;
  double fontSize = 16;
  String language = "English";
  double dailyGoal = 30; // minutes
  bool notificationsEnabled = true;
  bool weeklyReports = true;
  double usageLimit = 60; // minutes
  String parentPassword = "****";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ✅ Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Color(0xFFD84C15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  "Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ✅ محتوى الصفحة
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle("Customization"),
                _buildSwitch("Dark Mode", darkMode, (val) {
                  setState(() => darkMode = val);
                }),
                _buildSlider("Font Size", fontSize, 12, 30, (val) {
                  setState(() => fontSize = val);
                }),
                _buildDropdown("Language", language, ["English", "Arabic"], (val) {
                  setState(() => language = val!);
                }),

                _buildSectionTitle("Learning & Reports"),
                _buildSlider("Daily Goal (minutes)", dailyGoal, 10, 120, (val) {
                  setState(() => dailyGoal = val);
                }),
                _buildSwitch("Weekly Reports to Parent", weeklyReports, (val) {
                  setState(() => weeklyReports = val);
                }),

                _buildSectionTitle("Notifications"),
                _buildSwitch("Enable Notifications", notificationsEnabled, (val) {
                  setState(() => notificationsEnabled = val);
                }),

                _buildSectionTitle("Parental Controls"),
                _buildSlider("Daily Usage Limit (minutes)", usageLimit, 30, 180, (val) {
                  setState(() => usageLimit = val);
                }),
                _buildTile("Parent Password", parentPassword, () {
                  // هنا ممكن تفتحي Dialog لإدخال الباسورد الجديد
                }),

                _buildSectionTitle("Support & Info"),
                _buildTile("FAQ", "Common questions", () {}),
                _buildTile("Contact Us", "Send email to support", () {}),
                _buildTile("About App", "Version 1.0", () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Helper Widgets

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SwitchListTile(
        title: Text(title),
        value: value,
        activeColor: Colors.purple,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSlider(
      String title, double value, double min, double max, Function(double) onChanged) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text("$title: ${value.toStringAsFixed(0)}"),
        subtitle: Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toStringAsFixed(0),
          activeColor: Colors.purple,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String title, String value, List<String> items, Function(String?) onChanged) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(title),
        trailing: DropdownButton<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTile(String title, String subtitle, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
