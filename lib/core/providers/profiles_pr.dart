import 'package:flutter/material.dart';
import 'package:sales_app/core/models/profile.dart';
import 'package:sales_app/core/services/profiles_s.dart';
import 'package:sales_app/locator.dart';

class ProfilesModel with ChangeNotifier {
  final ProfilesService _profileService = locator<ProfilesService>();

// List of Profiles
  List<Profile> _profiles = [];
  bool isProfilesFetched = false;

  set profiles(List<Profile> newProfiles) {
    _profiles = newProfiles;
    isProfilesFetched = true;
    notifyListeners();
  }

  List<Profile> get profiles => _profiles;

  getProfiles() async {
    profiles = await _profileService.getProfiles();
  }

  Future<void> profileCreate({@required Profile? profile}) async {
    await _profileService.profileCreate(profile: profile);
  }

  Future<void> profileFollowupCreate(
      {@required Profile? profile,
      @required ProfileFollowUps? profileFollowup}) async {
    await _profileService.profileFollowupCreate(
        profile: profile, profileFollowup: profileFollowup);
  }
}
