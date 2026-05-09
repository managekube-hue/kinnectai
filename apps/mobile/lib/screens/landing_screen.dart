import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Desktop/Web layout
            return _buildDesktopLayout(context);
          } else {
            // Mobile layout
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left side - Hero section
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Every family has a Memory.',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Connect with your lineage. Discover forgotten stories and find your kin in our global family tree.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 48),
                _buildFamilyTreeGraphic(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.family_restroom, size: 32, color: Colors.deepPurple),
                    const SizedBox(width: 12),
                    Text(
                      'KinnectJai',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Right side - Auth section
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: _buildAuthCard(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Mobile hero section
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Every family has a Memory.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connect with your lineage. Discover forgotten Memories and find your kin in our global family tree.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildFamilyTreeGraphic(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.family_restroom, size: 24, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Text(
                      'KinnectJai',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Mobile auth section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(32),
            child: _buildAuthCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyTreeGraphic() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        painter: FamilyTreePainter(),
        child: const Center(
          child: Text(
            'Global Family Tree',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // App download buttons (desktop only)
        if (MediaQuery.of(context).size.width > 800)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildDownloadButton('App Store', Icons.phone_iphone),
              const SizedBox(width: 12),
              _buildDownloadButton('Google Play', Icons.android),
            ],
          ),
        const SizedBox(height: 24),
        // Tabs
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isLogin = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _isLogin ? Colors.black : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'LOG IN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isLogin ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isLogin = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: !_isLogin ? Colors.black : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'SIGN UP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: !_isLogin ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Enter your Memory Box',
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // OAuth buttons
        _buildOAuthButton('Continue with Google', 'G', Colors.red),
        const SizedBox(height: 12),
        _buildOAuthButton('Continue with Facebook', 'f', Colors.blue),
        const SizedBox(height: 12),
        _buildOAuthButton('Continue with TikTok', 'T', Colors.black),
        const SizedBox(height: 24),
        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('OR', style: TextStyle(color: Colors.grey.shade600)),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 24),
        // Email and Phone
        _buildAuthButton('Continue with Email', Icons.email, () {
          AppNav.push(context, _isLogin ? '/login' : '/register');
        }),
        const SizedBox(height: 12),
        _buildAuthButton('Continue with Phone', Icons.phone, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone authentication coming soon!')),
          );
        }),
        const SizedBox(height: 24),
        // Terms
        Text(
          'By joining, you agree to our Terms of Service',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDownloadButton(String text, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildOAuthButton(String text, String initial, Color color) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$text coming soon!')),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildAuthButton(String text, IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}

class FamilyTreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw simple tree structure
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw connections
    canvas.drawLine(
      Offset(size.width / 2, 20),
      center,
      paint,
    );
    
    // Draw branches
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * 3.14159 / 180;
      final endX = center.dx + 60 * (i % 2 == 0 ? 1 : -1) * (i < 3 ? 1 : 0.5);
      final endY = center.dy + 60 * (i < 3 ? 0.5 : 1);
      canvas.drawLine(center, Offset(endX, endY), paint);
      
      // Draw nodes
      canvas.drawCircle(Offset(endX, endY), 8, Paint()..color = Colors.deepPurple);
    }
    
    // Draw center node
    canvas.drawCircle(center, 12, Paint()..color = Colors.deepPurple);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



