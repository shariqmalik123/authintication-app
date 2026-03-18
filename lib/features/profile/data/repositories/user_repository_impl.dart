import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfileEntity> getUserProfile(String uid) async {
    return await remoteDataSource.getUserProfile(uid);
  }

  @override
  Future<void> updateUserProfile(UserProfileEntity profile) async {
    // would need to convert entity to model here
    throw UnimplementedError();
  }
}
