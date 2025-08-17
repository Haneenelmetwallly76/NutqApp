import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onGetStarted;
  const WelcomeScreen({super.key, required this.onGetStarted});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _starCtr;
  late final AnimationController _heartCtr;
  late final Animation<double> _starDy;
  late final Animation<double> _heartDy;

  bool _signingIn = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _starCtr = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _heartCtr = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600))
      ..repeat(reverse: true);
    _starDy = Tween<double>(begin: 0, end: 14).animate(
        CurvedAnimation(parent: _starCtr, curve: Curves.easeInOut));
    _heartDy = Tween<double>(begin: 0, end: 16).animate(
        CurvedAnimation(parent: _heartCtr, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _starCtr.dispose();
    _heartCtr.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() => _signingIn = true);
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _showRoleDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _signingIn = false);
    }
  }

  void _showRoleDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Choose your role",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRoleButton("Child 👶"),
            const SizedBox(height: 10),
            _buildRoleButton("Parent 👩‍👧"),
            const SizedBox(height: 10),
            _buildRoleButton("Doctor 🩺"),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(String role) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          if (role.startsWith("Child")) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ChildInterestsScreen()),
            );
          } else {
            widget.onGetStarted();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Signed up as $role")),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          backgroundColor: const Color(0xFF6366F1),
        ),
        child: Text(role, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF5F7FA), Color(0xFFE0E7FF)],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: gradient),
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                left: 24,
                top: 60,
                child: AnimatedBuilder(
                  animation: _starDy,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, -_starDy.value),
                    child: const Icon(Icons.star,
                        color: Colors.amber, size: 26),
                  ),
                ),
              ),
              Positioned(
                right: 28,
                top: 90,
                child: AnimatedBuilder(
                  animation: _heartDy,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, -_heartDy.value),
                    child: const Icon(Icons.favorite,
                        color: Colors.pinkAccent, size: 22),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/images/NUTQ App Logo  (1).png',
                          width: 110,
                          height: 110,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 28),

                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Welcome to ',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827)),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                const LinearGradient(
                                  colors: [
                                    Color(0xFF6366F1),
                                    Color(0xFF9333EA)
                                  ],
                                ).createShader(bounds),
                            child: const Text(
                              'NOUTQ!',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      const Text(
                        'Welcome to our amazing learning adventure!\n'
                            'A magical place where learning meets fun through\n'
                            'interactive games, speech activities, and personalized\n'
                            'adventures.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            height: 1.4),
                      ),
                      const SizedBox(height: 18),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.people_alt_outlined,
                              size: 18, color: Color(0xFF7C3AED)),
                          SizedBox(width: 8),
                          Text(
                            'Join thousands of happy learners!',
                            style: TextStyle(
                                color: Color(0xFF7C3AED),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),

                      SizedBox(
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0x336363F1),
                                  blurRadius: 10,
                                  offset: Offset(0, 6)),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                    const ChildInterestsScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)),
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Get Started! 🔑',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: const [
                          Expanded(
                              child: Divider(color: Color(0xFFD1D5DB))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('or',
                                style: TextStyle(color: Color(0xFF9CA3AF))),
                          ),
                          Expanded(
                              child: Divider(color: Color(0xFFD1D5DB))),
                        ],
                      ),
                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _signingIn ? null : _handleGoogleSignIn,
                          icon: Image.asset('assets/images/google_icon.png',
                              height: 18),
                          label: Text(
                            _signingIn
                                ? 'Signing in...'
                                : 'Continue with Google',
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(
                                color: Color(0xFFD1D5DB)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: _showRoleDialog,
                        child: const Text(
                          "Don’t have an account? Create one",
                          style: TextStyle(
                              color: Color(0xFF6366F1),
                              fontWeight: FontWeight.w600),
                        ),
                      ),

                      const Text(
                        'Your data is secure and we respect your privacy.\n'
                            'We use Google for easy sign-in and progress syncing.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                            height: 1.35),
                      ),
                    ],
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

// 🔽 شاشة اهتمامات الطفل
class ChildInterestsScreen extends StatefulWidget {
  const ChildInterestsScreen({super.key});

  @override
  State<ChildInterestsScreen> createState() => _ChildInterestsScreenState();
}

class _ChildInterestsScreenState extends State<ChildInterestsScreen> {
  final List<Map<String, String>> interests = [
    {'id': 'animals', 'label': 'Animals', 'icon': '🐼'},
    {'id': 'colors', 'label': 'Colors', 'icon': '🌈'},
    {'id': 'numbers', 'label': 'Numbers', 'icon': '🔢'},
    {'id': 'letters', 'label': 'Letters', 'icon': '📝'},
    {'id': 'music', 'label': 'Music', 'icon': '🎵'},
    {'id': 'stories', 'label': 'Stories', 'icon': '📚'},
  ];

  final Set<String> selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,  // عرض متوسط
          height: MediaQuery.of(context).size.height * 0.6, // ارتفاع متوسط
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "What do you love learning about?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Pick your favorite topics",
                    style: TextStyle(
                        fontSize: 14, color: Color(0xFF6B7280), height: 1.3),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: interests.map((item) {
                        final isSelected = selected.contains(item['id']);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selected.remove(item['id']!);
                              } else {
                                selected.add(item['id']!);
                              }
                            });
                          },
                          child: Card(
                            color: isSelected
                                ? Colors.purple.shade100
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(item['icon']!, style: const TextStyle(fontSize: 32)),
                                  const SizedBox(height: 8),
                                  Text(item['label']!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Back"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          debugPrint("Selected interests: $selected");
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("Let's Learn! 🎉"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
