import 'package:epilepsy_care_pmk/screens/home/alarm_med_take/alarm_med_take.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/graph_history.dart';
import 'package:epilepsy_care_pmk/screens/home/profile/profile.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: const Text('ข้อมูลส่วนตัว'),
            // visualDensity: VisualDensity(vertical: -3),  // Making the tile more compact
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const profile()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.data_thresholding_outlined),
            title: const Text('ประวัติการชักเเละการรับประทานยา'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const graphHistory()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.alarm),
            title: const Text('ตั้งเวลากินยา'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const alarmMedTake()));
            },
          ),
        ],
      ),
    );
  }
}
