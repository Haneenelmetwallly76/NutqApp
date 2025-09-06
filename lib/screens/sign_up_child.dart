import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';

class SignUpChild extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final interestsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up as Child')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: interestsController,
              decoration: InputDecoration(labelText: 'Interests (e.g., animals, colors)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).updateUser(
                  role: 'Child',
                  name: nameController.text,
                  age: ageController.text,
                );
                Navigator.pushReplacementNamed(context, '/dashboard', arguments: 'Child');
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}