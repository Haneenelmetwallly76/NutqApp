import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor; // اضفنا
  final Color? iconColor;       // اضفنا

  const ActivityCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.backgroundColor, // افتراضي null
    this.iconColor,       // افتراضي null
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor ?? Colors.orange[50], // يستخدم اللون الافتراضي إذا لم يتم تمريره
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 36, color: iconColor ?? Colors.orange[800]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: iconColor ?? Colors.orange[900], // خلي لون العنوان متناسق مع الايقون
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
