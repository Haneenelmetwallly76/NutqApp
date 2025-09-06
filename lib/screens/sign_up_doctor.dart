import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';
import 'parent_dashboard.dart';
import 'doctor_dashboard.dart';

class SignUpDoctor extends ConsumerWidget {
  const SignUpDoctor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final qualificationController = TextEditingController();
    final licenseController = TextEditingController();
    final roleController = TextEditingController(); // لو عايزة user يختار دوره

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: qualificationController,
              decoration: const InputDecoration(labelText: 'Qualifications (Doctor Only)'),
            ),
            TextField(
              controller: licenseController,
              decoration: const InputDecoration(labelText: 'License Number (Doctor Only)'),
            ),
            const SizedBox(height: 20),
            // اختيار الدور لو تحبي
            DropdownButton<String>(
              value: ref.watch(userProvider).role.isEmpty ? null : ref.watch(userProvider).role,
              hint: const Text('Select Role'),
              items: const [
                DropdownMenuItem(value: 'Parent', child: Text('Parent')),
                DropdownMenuItem(value: 'Doctor', child: Text('Doctor')),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(userProvider.notifier).updateUser(role: value);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final userRole = ref.read(userProvider).role;

                // تحديث بيانات
                if (userRole == 'Doctor') {
                  ref.read(userProvider.notifier).updateUser(
                    name: nameController.text,
                    qualifications: qualificationController.text,
                    licenseNumber: licenseController.text,
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DoctorDashboard()),
                  );
                } else {
                  // لو Parent
                  ref.read(userProvider.notifier).updateUser(
                    name: nameController.text,
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ParentDashboard()),
                  );
                }
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
