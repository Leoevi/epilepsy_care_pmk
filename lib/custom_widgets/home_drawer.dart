import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/graph_history.dart';
import 'package:epilepsy_care_pmk/screens/home/profile/profile.dart';
import 'package:epilepsy_care_pmk/screens/register.dart';
import 'package:flutter/material.dart';

import '../screens/home/alarm_med_intake/alarm_med_intake.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    this.icon,
    this.name,
  });

  final ImageProvider<Object>? icon;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: kCircleRadius,
                  backgroundImage: icon,
                ),
                const SizedBox(
                  width: kSmallPadding,
                ),
                Expanded(child: Text(name ?? "Full Name"))
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: const Text('ข้อมูลส่วนตัว'),
            // visualDensity: VisualDensity(vertical: -3),  // Making the tile more compact
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Profile()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.data_thresholding_outlined),
            title: const Text('ประวัติการชักเเละการรับประทานยา'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const GraphHistory()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.alarm),
            title: const Text('ตั้งเวลากินยา'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AlarmMedIntake()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.alarm),
            title: const Text('test register page'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Register()));
            },
          ),
        ],
      ),
    );
  }
}
