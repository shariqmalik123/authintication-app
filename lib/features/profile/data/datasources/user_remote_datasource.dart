import '../models/user_profile_model.dart';

abstract class UserRemoteDataSource {
  Future<UserProfileModel> getUserProfile(String uid);
  Future<void> updateUserProfile(UserProfileModel profile);
}
