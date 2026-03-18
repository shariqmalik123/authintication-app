import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password);
  Future<void> logout();
  Stream<UserModel?> authStateChanges();
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required int age,
  });
}

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
      email: email,
      password: password,
    );
    
    // Fetch complete user data from Firestore
    final userDoc = await firebaseFirestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();
    
    if (userDoc.exists) {
      return UserModel.fromFirestore(userDoc.data()!);
    }
    
    return UserModel.fromFirebaseUser(credential.user!);
  }

  @override
  Future<UserModel> register(String email, String password) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Check if user profile exists in Firestore
    final userDoc = await firebaseFirestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();
    
    if (userDoc.exists) {
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
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userData = {
      'uid': credential.user!.uid,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Store additional user data in Firestore
    await firebaseFirestore
        .collection('users')
        .doc(credential.user!.uid)
        .set(userData);

    // Return UserModel with complete data
    return UserModel(
      uid: credential.user!.uid,
      email: email,
      name: name,
      phone: phone,
      age: age,
    );
  }
}
