// lib/auth/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Current user ────────────────────────────────────
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool get isLoggedIn => _auth.currentUser != null;

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // ── Register ─────────────────────────────────────────
  Future<AuthResult> registerWithEmail({
    required String masjidName,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;

      // Update display name
      await user.updateDisplayName(masjidName.trim());

      // Save masjid data in Firestore under users/{uid}
      await _db.collection('users').doc(user.uid).set({
        'masjidName': masjidName.trim(),
        'email': email.trim().toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
        'uid': user.uid,
      });

      // Send email verification
      await user.sendEmailVerification();

      return AuthResult(
        success: true,
        message: 'Registration successful! Please verify your email.',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, message: _authErrorMessage(e.code));
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  // ── Login ────────────────────────────────────────────
  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;

      // Check email verification
      if (!user.emailVerified) {
        await _auth.signOut();
        return AuthResult(
          success: false,
          message: 'Please verify your email before logging in.',
          needsVerification: true,
        );
      }

      return AuthResult(success: true, message: 'Login successful!');
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, message: _authErrorMessage(e.code));
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  // ── Resend verification email ─────────────────────────
  Future<AuthResult> resendVerificationEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.sendEmailVerification();
      await _auth.signOut();
      return AuthResult(success: true, message: 'Verification email sent!');
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Could not send verification email.',
      );
    }
  }

  // ── Get user masjid data ──────────────────────────────
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  // ── Logout ────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ── Firebase error messages (Urdu/English) ────────────
  String _authErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'this email is already registered. Please login or use a different email.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password must be at least 6 characters long.';
      case 'user-not-found':
        return 'This email is not registered. Please sign up or use a different email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Error: $code. Please try again.';
    }
  }
}

// ── Result model ──────────────────────────────────────
class AuthResult {
  final bool success;
  final String message;
  final bool needsVerification;

  const AuthResult({
    required this.success,
    required this.message,
    this.needsVerification = false,
  });
}
