import 'package:flutter/material.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';

class ProfileProvider extends ChangeNotifier {
  final GetUserProfileUseCase getUserProfileUseCase;

  ProfileProvider({required this.getUserProfileUseCase});

  bool isLoading = false;
  UserProfileEntity? userProfile;
  String? errorMessage;

  Future<void> loadUserProfile(String uid) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      userProfile = await getUserProfileUseCase(uid);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
     
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
