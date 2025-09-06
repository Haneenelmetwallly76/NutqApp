// doctor_settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_notq_app/screens/doctor_provider.dart';

class DoctorSettingsPage extends ConsumerWidget {
  const DoctorSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = ref.watch(doctorProvider);
    final nameController = TextEditingController(text: doctor.name);
    final qualController = TextEditingController(text: doctor.qualifications);
    final licenseController = TextEditingController(text: doctor.licenseNumber);

    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Settings'), backgroundColor: Colors.green[600]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: qualController, decoration: const InputDecoration(labelText: 'Qualifications')),
            TextField(controller: licenseController, decoration: const InputDecoration(labelText: 'License Number')),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
              onPressed: () {
                ref.read(doctorProvider.notifier).updateDoctor(
                  name: nameController.text,
                  qualifications: qualController.text,
                  licenseNumber: licenseController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved successfully!')));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
