import 'individual_bar.dart';

class BarData {
  final double firstDay;
  final double secondDay;
  final double thirdDay;
  final double fourthDay;
  final double fifthDay;

  BarData({
    required this.firstDay,
    required this.secondDay,
    required this.thirdDay,
    required this.fourthDay,
    required this.fifthDay,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: firstDay),
      IndividualBar(x: 0, y: secondDay),
      IndividualBar(x: 0, y: thirdDay),
      IndividualBar(x: 0, y: fourthDay),
      IndividualBar(x: 0, y: fifthDay),
    ];
  }
}