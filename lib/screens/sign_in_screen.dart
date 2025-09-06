import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Sign In as ${user.role.isNotEmpty ? user.role : "User"}')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).updateUser(
                  role: user.role.isNotEmpty ? user.role : 'Child',
                  username: usernameController.text,
                  password: passwordController.text,
                );
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}