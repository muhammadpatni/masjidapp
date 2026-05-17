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

      return AuthResult(success: true, message: 'Registration successful! Please verify your email.');
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, message: _authErrorMessage(e.code));
    } catch (e) {
      return AuthResult(success: false, message: 'Something went wrong. Please try again.');
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
      return AuthResult(success: false, message: 'Something went wrong. Please try again.');
    }
  }

  // ── Resend verification email ─────────────────────────
  Future<AuthResult> resendVerificationEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.sendEmailVerification();
      await _auth.signOut();
      return AuthResult(success: true, message: 'Verification email sent!');
    } catch (e) {
      return AuthResult(success: false, message: 'Could not send verification email.');
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
        return 'Yeh email pehle se registered hai.';
      case 'invalid-email':
        return 'Email format galat hai.';
      case 'weak-password':
        return 'Password kam az kam 6 characters ka hona chahiye.';
      case 'user-not-found':
        return 'Yeh email registered nahi hai.';
      case 'wrong-password':
        return 'Password galat hai.';
      case 'invalid-credential':
        return 'Email ya password galat hai.';
      case 'user-disabled':
        return 'Yeh account disable kar diya gaya hai.';
      case 'too-many-requests':
        return 'Bahut zyada attempts. Thodi der baad try karein.';
      case 'network-request-failed':
        return 'Internet connection check karein.';
      default:
        return 'Error: $code. Dobara try karein.';
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
