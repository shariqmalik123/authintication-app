import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';
import 'user_remote_datasource.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl({required this.firestore});

  @override
  Future<UserProfileModel> getUserProfile(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return UserProfileModel.fromJson(doc.data()!);
      } else {
        throw Exception('User profile not found');
      }
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel profile) async {
    try {
      await firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}
