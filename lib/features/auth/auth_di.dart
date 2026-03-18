import 'package:auth_screen/features/auth/data/datasources/auth_remote_datasource.dart' hide AuthRemoteDataSourceImpl;
import 'package:auth_screen/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import '../../app/injection_container.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/sign_up_usecase.dart';
import 'presentation/providers/auth_provider.dart';
Future<void> initAuthDependencies() async {

  // Firebase instances
  di.registerLazySingleton(() => FirebaseAuth.instance);
  di.registerLazySingleton(() => FirebaseFirestore.instance);

  // Data source
  di.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: di(),
      firebaseFirestore: di(),
    ),
  );

  // Repository (Data -> Domain boundary)
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: di(),
    ),
  );

  // Use case (business logic)
  di.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(di()),
  );

  // Provider (presentation layer)
  di.registerFactory<AuthProvider>(
    () => AuthProvider(
      signUpUseCase: di(),
    ),
  );
}
