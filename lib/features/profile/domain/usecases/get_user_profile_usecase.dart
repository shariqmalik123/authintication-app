import '../entities/user_profile_entity.dart';
import '../repositories/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfileEntity> call(String uid) {
    return repository.getUserProfile(uid);
  }
}
