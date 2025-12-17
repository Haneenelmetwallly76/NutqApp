import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';

class SignUpParent extends ConsumerWidget {
  const SignUpParent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final childNameController = TextEditingController();
    final phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up as Parent')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Parent Name'),
            ),
            TextField(
              controller: childNameController,
              decoration: const InputDecoration(labelText: 'Child Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).updateUser(
                  role: 'Parent',
                  name: nameController.text,
                  childName: childNameController.text,
                  phone: phoneController.text,
                );
                Navigator.pushReplacementNamed(context, '/parent');              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}