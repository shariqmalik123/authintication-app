import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app/injection_container.dart';
import 'data/datasources/user_remote_datasource.dart';
import 'data/datasources/user_remote_datasource_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/get_user_profile_usecase.dart';
import 'presentation/provider/profile_provider.dart';

Future<void> initProfileDependencies() async {
  // data sources
  di.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(firestore: FirebaseFirestore.instance),
  );

  // repositories
  di.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: di()),
  );

  // use cases
  di.registerLazySingleton(() => GetUserProfileUseCase(di()));

  // providers
  di.registerFactory(() => ProfileProvider(getUserProfileUseCase: di()));
}
