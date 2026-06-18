import 'package:firebase_auth/firebase_auth.dart' hide FirebaseException;

import '../error/exceptions.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<String> signInAnonymously() async {
    try {
      final current = _firebaseAuth.currentUser;
      if (current != null) return current.uid;

      final credential = await _firebaseAuth.signInAnonymously();
      final user = credential.user;
      if (user == null) {
        throw const FirebaseException('Anonymous sign-in returned no user.');
      }
      return user.uid;
    } catch (error) {
      throw FirebaseException('Anonymous sign-in failed: $error');
    }
  }

  Future<String> getCurrentUid() async {
    final current = _firebaseAuth.currentUser;
    if (current != null) return current.uid;
    return signInAnonymously();
  }
}
