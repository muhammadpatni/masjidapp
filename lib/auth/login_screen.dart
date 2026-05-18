// lib/auth/login_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjidapp/auth/auth_service.dart';
import 'package:masjidapp/auth/register_screen.dart';
import 'package:masjidapp/screens/main_screen.dart';
import 'package:masjidapp/constants/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Login ───────────────────────────────────────────
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.loginWithEmail(
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const MainScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    } else {
      setState(() => _errorMessage = result.message);
      if (result.needsVerification) {
        _showResendDialog();
      }
    }
  }

  // ── Resend verification dialog ───────────────────────
  void _showResendDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0F3D2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'verification pending',
          style: GoogleFonts.cairo(color: kGold, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Would you like to resend the verification link?',
          style: GoogleFonts.cairo(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel',
              style: GoogleFonts.cairo(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final r = await _authService.resendVerificationEmail(
                _emailCtrl.text,
                _passwordCtrl.text,
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(r.message, style: GoogleFonts.cairo()),
                    backgroundColor: r.success
                        ? const Color(0xFF1A5C2A)
                        : Colors.red.shade800,
                  ),
                );
              }
            },
            child: Text('resend', style: GoogleFonts.cairo(color: kGold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryDark,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.4),
                radius: 1.2,
                colors: [Color(0xFF0F3D2E), Color(0xFF071E16), kPrimaryDark],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── Logo ──────────────────────────────
                          _buildLogo(),
                          const SizedBox(height: 32),

                          // ── Title ─────────────────────────────
                          Text(
                            'خوش آمدید',
                            style: GoogleFonts.amiri(
                              fontSize: 28,
                              color: kGold,
                              fontWeight: FontWeight.bold,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'login to your account',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // ── Card ──────────────────────────────
                          _buildCard(),
                          const SizedBox(height: 24),

                          // ── Register link ─────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: GoogleFonts.cairo(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                ),
                                child: Text(
                                  'Register here',
                                  style: GoogleFonts.cairo(
                                    color: kGold,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF1A4D38), Color(0xFF0A2E24)],
        ),
        border: Border.all(color: kGold.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kGold.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(Icons.mosque_rounded, color: kGold, size: 44),
    );
  }

  Widget _buildCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kGold.withOpacity(0.15), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Error message
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.cairo(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Email field
              _buildTextField(
                controller: _emailCtrl,
                label: 'Email',
                hint: 'masjid@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'please enter your email';
                  }
                  if (!v.contains('@') || !v.contains('.')) {
                    return 'add valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password field
              _buildTextField(
                controller: _passwordCtrl,
                label: 'Password',
                hint: '••••••••',
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white38,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Login button
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: kGold))
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGold,
                        foregroundColor: kPrimaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryDark,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 14),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.cairo(color: Colors.white24, fontSize: 14),
            prefixIcon: Icon(icon, color: kGold.withOpacity(0.7), size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white.withOpacity(0.07),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kGold.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kGold.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kGold.withOpacity(0.6), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            errorStyle: GoogleFonts.cairo(
              color: Colors.redAccent,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
