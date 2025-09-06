import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';

class SignUpParent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final childNameController = TextEditingController();
    final phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up as Parent')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Parent Name'),
            ),
            TextField(
              controller: childNameController,
              decoration: InputDecoration(labelText: 'Child Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).updateUser(
                  role: 'Parent',
                  name: nameController.text,
                  childName: childNameController.text,
                  phone: phoneController.text,
                );
                Navigator.pushReplacementNamed(context, '/parent');              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}