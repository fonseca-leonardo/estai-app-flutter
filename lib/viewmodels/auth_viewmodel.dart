import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordResetSent = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPasswordResetSent => _isPasswordResetSent;
  bool get isAuthenticated => _currentUser != null;

  AuthViewModel() {
    _currentUser = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _isPasswordResetSent = false;
    notifyListeners();

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _currentUser = userCredential.user;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          _errorMessage = 'invalidEmailOrPassword';
          break;
        case 'invalid-email':
          _errorMessage = 'invalidEmail';
          break;
        case 'user-disabled':
          _errorMessage = 'userDisabled';
          break;
        case 'too-many-requests':
          _errorMessage = 'tooManyRequests';
          break;
        default:
          _errorMessage = 'loginError:${e.message ?? ''}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'loginError:$e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name.trim());
        await userCredential.user!.reload();
        _currentUser = _auth.currentUser;
      }

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'weak-password':
          _errorMessage = 'weakPassword';
          break;
        case 'email-already-in-use':
          _errorMessage = 'emailAlreadyInUse';
          break;
        case 'invalid-email':
          _errorMessage = 'invalidEmail';
          break;
        default:
          _errorMessage = 'signUpError:${e.message ?? ''}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'signUpError:$e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _isPasswordResetSent = false;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      _isLoading = false;
      _isPasswordResetSent = true;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = 'emailNotFound';
          break;
        case 'invalid-email':
          _errorMessage = 'invalidEmail';
          break;
        default:
          _errorMessage = 'sendEmailError:${e.message ?? ''}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'sendEmailError:$e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    _isPasswordResetSent = false;
    notifyListeners();

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      googleSignIn.initialize(
        serverClientId:
            '952848614020-otvqsp6pru3ur4s4tmls2i5u7eg2k6k3.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        _isLoading = false;
        _errorMessage = 'googleSignInCancelled';
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        _isLoading = false;
        _errorMessage = 'googleSignInFailed:Tokens não disponíveis';
        notifyListeners();
        return false;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      _currentUser = userCredential.user;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'network-request-failed':
          _errorMessage = 'networkError';
          break;
        case 'account-exists-with-different-credential':
          _errorMessage = 'accountExistsWithDifferentCredential';
          break;
        case 'operation-not-allowed':
          _errorMessage = 'operationNotAllowed';
          break;
        case 'user-disabled':
          _errorMessage = 'userDisabled';
          break;
        default:
          _errorMessage = 'googleSignInError:${e.message ?? ''}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'googleSignInFailed:$e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    _isLoading = true;
    _errorMessage = null;
    _isPasswordResetSent = false;
    notifyListeners();

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        final givenName = appleCredential.givenName ?? '';
        final familyName = appleCredential.familyName ?? '';
        final displayName = '$givenName $familyName'.trim();
        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
          await userCredential.user!.reload();
        }
      }

      _currentUser = userCredential.user;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on SignInWithAppleAuthorizationException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          _errorMessage = 'appleSignInCancelled';
          break;
        default:
          _errorMessage = 'appleSignInFailed:${e.toString()}';
      }
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'network-request-failed':
          _errorMessage = 'networkError';
          break;
        case 'account-exists-with-different-credential':
          _errorMessage = 'accountExistsWithDifferentCredential';
          break;
        case 'operation-not-allowed':
          _errorMessage = 'operationNotAllowed';
          break;
        case 'user-disabled':
          _errorMessage = 'userDisabled';
          break;
        default:
          _errorMessage = 'appleSignInError:${e.message ?? ''}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'appleSignInFailed:$e';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();
      await _auth.signOut();
      _currentUser = null;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'logoutError:$e';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetPasswordResetState() {
    _isPasswordResetSent = false;
    notifyListeners();
  }

  Future<bool> deleteAccount(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _currentUser;
      if (user == null) {
        _isLoading = false;
        _errorMessage = 'deleteAccountError:No user logged in';
        notifyListeners();
        return false;
      }

      // 1. Delete all routes from Firestore
      try {
        final firestore = FirebaseFirestore.instance;
        final routesCollection = firestore
            .collection('estai')
            .doc(userId)
            .collection('routes');
        
        final routesSnapshot = await routesCollection.get();
        final batch = firestore.batch();
        for (final doc in routesSnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      } catch (e) {
        debugPrint('Error deleting routes from Firestore: $e');
        // Continue even if routes deletion fails
      }

      // 2. Delete local routes from SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('local_routes');
      } catch (e) {
        debugPrint('Error deleting local routes: $e');
        // Continue even if local deletion fails
      }

      // 3. Delete Firebase Auth account (last step)
      await user.delete();

      // Sign out Google if applicable
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn.instance;
        await googleSignIn.signOut();
      } catch (e) {
        debugPrint('Error signing out from Google: $e');
      }

      _currentUser = null;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'requires-recent-login':
          _errorMessage = 'deleteAccountRequiresRecentLogin';
          break;
        default:
          _errorMessage = 'deleteAccountError:${e.message ?? e.code}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'deleteAccountError:$e';
      notifyListeners();
      return false;
    }
  }
}
