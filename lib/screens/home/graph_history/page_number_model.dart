import 'package:flutter/foundation.dart';

/// A model that contains the current page number on MedIntakeHistory page
class PageNumberModel with ChangeNotifier {
  int _currentPageNumber;

  PageNumberModel(this._currentPageNumber);

  int get currentPageNumber => _currentPageNumber;

  set currentPageNumber(int newPageNumber) {
    _currentPageNumber = newPageNumber;
    notifyListeners();
  }
}