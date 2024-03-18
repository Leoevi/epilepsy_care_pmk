import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';

/// A parent class for every event types. It exists because we wanted to
/// be able to sort every event by date.
abstract class Event implements Comparable<Event> {
  /// [time] stored as unix time (seconds since epoch) (with UTC timezone).
  ///
  /// Can be converted to DateTime object with [unixTimeToDateTime].
  abstract final int time;

  const Event();

  // https://stackoverflow.com/questions/53547997/sort-a-list-of-objects-in-flutter-dart-by-property-value
  @override
  int compareTo(Event other) => time.compareTo(other.time);
}