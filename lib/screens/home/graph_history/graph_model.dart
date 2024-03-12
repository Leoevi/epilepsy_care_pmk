import 'package:epilepsy_care_pmk/models/med_intake_per_day.dart';
import 'package:flutter/foundation.dart';

// For more info on ChangeNotifier: https://docs.flutter.dev/data-and-backend/state-mgmt/simple#changenotifierprovider

/// A model that contains medIntakePerDay for displaying the graph.
/// Will be set by onPageChange callback, and will be get by the graph.
class GraphModel with ChangeNotifier {  // ChangeNotifier make the class have listening capabilities.
  // Make this private so that we can specified custom get/set functions.
  List<MedIntakePerDay> _medIntakePerDays;

  GraphModel(this._medIntakePerDays);

  // get is normal
  List<MedIntakePerDay> get medIntakePerDays => _medIntakePerDays;

  // Add set with notifyListener so that when the value is set, the consumer of
  // ChangeNotifier will know to rebuild.
  set medIntakePerDays(List<MedIntakePerDay> newValue) {
    _medIntakePerDays = newValue;
    notifyListeners();
  }
}