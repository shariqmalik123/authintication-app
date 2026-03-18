import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_up_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;

  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({required this.signUpUseCase});

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String ageString,
  }) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final age = int.tryParse(ageString.trim()) ?? 0;

      _user = await signUpUseCase(
        email: email,
        password: password,
        name: name,
        phone: phone,
        age: age,
      );
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Registration failed';
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
