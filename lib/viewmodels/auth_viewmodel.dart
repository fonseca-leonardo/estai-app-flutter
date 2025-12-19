import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
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
}


