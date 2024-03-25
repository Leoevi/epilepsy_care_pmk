import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/image_utility.dart';
import '../main.dart';

// You know, if for some reason we want to implement a setting feature
// (theme/language/etc) we could just conjure another service class like this,
// and user that with change notifier like this.

/// A singleton class that provides user information.
class UserProfileService with ChangeNotifier {
  // Singleton pattern from https://stackoverflow.com/a/12649574
  static final UserProfileService _singleton = UserProfileService._internal();
  /// Returns a singleton instance of [UserProfileService] which provides user
  /// information. All fields are read-only but can be overridden by calling
  /// [saveToPref] with new data to override the old one.
  factory UserProfileService() {
    return _singleton;
  }
  UserProfileService._internal() {
    _isRegistered = prefs.getString('hn') == null;

    if (!_isRegistered) {
      // _image = ;
      _hn = prefs.getString('hn')!;
      _firstName = prefs.getString('firstName')!;
      _lastName = prefs.getString('lastName')!;
      _gender = prefs.getString('gender')!;
      String birthDateTimestamp = prefs.getString('birthDate')!;
      _birthDate = DateTime.parse(birthDateTimestamp);
    }
  }

  // These fields will be read-only, hence the getters.
  late bool _isRegistered;
  late Image? _image;
  late String _hn;
  late String _firstName;
  late String _lastName;
  late DateTime _birthDate;
  late String _gender;

  /// Returns whether or not the if user has registered. If ```false```,
  /// it means that all the other fields won't have been initialized.
  /// (And calling them will lead to a [LateInitializationError])
  get isRegistered => _isRegistered;

  get image => _image;

  get hn => _hn;

  get firstName => _firstName;

  get lastName => _lastName;

  get birthDate => _birthDate;

  get gender => _gender;

  /// Save the passed in data to shared preference and also notify other listeners.
  /// If a newImage isn't passed in, then clear the old image
  /// (So normal edits will have to pass in the image every time).
  void saveToPref(Image? newImage, String newHn, String newFirstName,
      String newLastName, DateTime newBirthDate, String newGender) async {
    // if (newImage != null) {
    //   List<int> imageBytes = ;
    //   String imageString = ImageUtility.base64String(await newImage.readAsBytes());
    //   _image = ImageUtility.imageFromBase64String(imageString);
    //   ImageUtility.saveImageToPreferences(imageString);
    // } else {
    //   prefs.remove("IMG_KEY");
    // }
    _hn = newHn;
    prefs.setString('hn', newHn);
    _firstName = newFirstName;
    prefs.setString('firstName', newFirstName);
    _lastName = newLastName;
    prefs.setString('lastName', newLastName);
    _birthDate = newBirthDate;
    prefs.setString('birthDate', newBirthDate.toIso8601String());
    _gender = newGender;
    prefs.setString('gender', newGender);

    _isRegistered = false;  // If the user clicked on save, then we know for sure that they are registered.

    notifyListeners();
  }
}
