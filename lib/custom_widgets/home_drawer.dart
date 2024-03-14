import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/helpers/image_utility.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/graph_history_with_ui.dart';
import 'package:epilepsy_care_pmk/screens/home/profile/profile.dart';
import 'package:epilepsy_care_pmk/screens/register.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home/alarm_med_intake/alarm_med_intake.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    super.key,
    
  });

  

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  String? firstName;
  String? lastName;
  Image? imageFromPreferences;

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
    
  }
  
  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        firstName = prefs.getString('firstName') ?? null;
      lastName = prefs.getString('lastName') ?? null;

      ImageUtility.getImageFromPreferences().then((img) {
        if (null == img) {
          return;
        }
        imageFromPreferences = ImageUtility.imageFromBase64String(img);
    });
      });
      
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: baseBackgroundDecoration,
            child: Row(
              children: [
                CircleAvatar(
                  radius: kCircleRadius,
                  backgroundImage: imageFromPreferences?.image ?? profilePlaceholder,
                ),
                const SizedBox(
                  width: kSmallPadding,
                ),
                Expanded(child: Text("$firstName $lastName"))
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
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const GraphHistory()));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const GraphHistoryWithTab()));
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
            leading: Icon(Icons.refresh),
            title: const Text('generateDummyData'),
            onTap: () {
              DatabaseService.generateDummyData(100,3);
            },
          ),
        ],
      ),
    );
  }
}
