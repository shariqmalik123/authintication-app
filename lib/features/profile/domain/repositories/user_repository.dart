import '../entities/user_profile_entity.dart';

abstract class UserRepository {
  Future<UserProfileEntity> getUserProfile(String uid);
  Future<void> updateUserProfile(UserProfileEntity profile);
}
