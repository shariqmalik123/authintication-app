import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required int age,
  }) async {
    return await remoteDataSource.signUp(
      email: email,
      password: password,
      name: name,
      phone: phone,
      age: age,
    );
  }

  @override
  Future<UserEntity> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<UserEntity> register(String email, String password) {
    return remoteDataSource.register(email, password);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return remoteDataSource.authStateChanges();
  }
}
