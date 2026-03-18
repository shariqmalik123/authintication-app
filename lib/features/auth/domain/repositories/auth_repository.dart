import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required int age,
  });
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password);
  Future<void> logout();
  Stream<UserEntity?> authStateChanges();
}
