import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final userId = credential.user?.uid;
    if (userId == null) {
      throw Exception('Failed to get user ID');
    }

    // Fetch complete user data from Firestore
    final userDoc = await firebaseFirestore
        .collection('users')
        .doc(userId)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      return UserModel.fromFirestore(userDoc.data()!);
    }

    return UserModel.fromFirebaseUser(credential.user!);
  }

  @override
  Future<UserModel> register(String email, String password) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final userId = credential.user?.uid;
    if (userId == null) {
      throw Exception('Failed to get user ID');
    }

    // Check if user profile exists in Firestore
    final userDoc = await firebaseFirestore
        .collection('users')
        .doc(userId)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      return UserModel.fromFirestore(userDoc.data()!);
    }

    return UserModel.fromFirebaseUser(credential.user!);
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return firebaseAuth.authStateChanges().map(
      (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
    );
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required int age,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final userId = userCredential.user?.uid;
    if (userId == null) {
      throw Exception('Failed to get user ID');
    }

    final userModel = UserModel(
      uid: userId,
      email: email.trim(),
      name: name.trim(),
      phone: phone.trim(),
      age: age,
    );

    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .set(userModel.toFirestore());

    return userModel;
  }
}
