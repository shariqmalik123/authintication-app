import 'package:auth_screen/core/providers/theme_provider.dart';
import 'package:auth_screen/core/services/image%20picker/image_picker_service.dart';
import 'package:auth_screen/core/services/local%20storage/local_storage_service.dart';
import 'package:auth_screen/core/services/network/network_service.dart';
import 'package:auth_screen/features/auth/auth_di.dart';
import 'package:auth_screen/features/profile/home_di.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

final di = GetIt.instance;

Future<void> initializeDependencies() async {
  // Local Storage Service
  di.registerLazySingleton<LocalStorageService>(() => LocalStorageService());

  // Image Picker Service
  di.registerLazySingleton<ImagePickerService>(
    () => ImagePickerService(picker: ImagePicker()),
  );

  // Connectivity
  di.registerLazySingleton(() => Connectivity());

  // Network Service
  di.registerLazySingleton<NetworkService>(() => NetworkService(di()));

  // Theme Provider Registering
  di.registerLazySingleton(() => ThemeProvider());

  // feature specific dependencies
  // Auth feature dependencies
  await initAuthDependencies();

  // Home feature dependencies
  await initProfileDependencies();
}
