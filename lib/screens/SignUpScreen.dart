import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final String role; // Child / Parent / Doctor
  const SignUpScreen({super.key, required this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();
  final _specialityCtrl = TextEditingController();
  final _licenseCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _detailsCtrl.dispose();
    _specialityCtrl.dispose();
    _licenseCtrl.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.role} account created successfully!")),
      );
      // هنا بقى تكملي تخزين البيانات في Firebase / DB
      Navigator.pop(context); // يرجع للصفحة الرئيسية أو يروح للـ Dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up as ${widget.role}"),
        backgroundColor: const Color(0xFF6366F1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) =>
                val == null || val.isEmpty ? "Required" : null,
              ),

              if (widget.role == "Child 👶") ...[
                TextFormField(
                  controller: _ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Age"),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: _detailsCtrl,
                  decoration:
                  const InputDecoration(labelText: "Condition Details"),
                ),
              ],

              if (widget.role == "Parent 👩‍👧") ...[
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextFormField(
                  controller: _detailsCtrl,
                  decoration:
                  const InputDecoration(labelText: "Child Details"),
                ),
              ],

              if (widget.role == "Doctor 🩺") ...[
                TextFormField(
                  controller: _specialityCtrl,
                  decoration: const InputDecoration(labelText: "Speciality"),
                ),
                TextFormField(
                  controller: _licenseCtrl,
                  decoration:
                  const InputDecoration(labelText: "License Number"),
                ),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
              ],

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
