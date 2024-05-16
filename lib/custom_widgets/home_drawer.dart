import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/graph_history_with_ui.dart';
import 'package:epilepsy_care_pmk/screens/home/profile/profile.dart';
import 'package:epilepsy_care_pmk/services/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';
import 'package:provider/provider.dart';

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
    super.initState();
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
            child: Consumer<UserProfileService>(
              builder: (context, model, child) => Row(
                children: [
                  CircleAvatar(
                    radius: kCircleRadius,
                    backgroundImage: model.image?.image ?? profilePlaceholder,
                  ),
                  const SizedBox(
                    width: kSmallPadding,
                  ),
                  Expanded(child: Text("${model.firstName} ${model.lastName}"))
                ],
              )
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
                  builder: (context) => const GraphHistoryWithTab()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.alarm),
            title: const Text('ตั้งเวลาแจ้งเตือนทานยา'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AlarmMedIntake()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.perm_device_info),
            title: const Text('เข้าสู่การสอนใช้งานครั้งแรก'),
            onTap: () {
              Navigator.of(context).pop();
              if (mounted) {
                final onboarding = Onboarding.of(context);
                if (onboarding != null) {
                  onboarding.show();
                } else {
                  print("onboarding is null");
                }
              }
            },
          ),
          Divider(),
          AboutListTile(
            // https://api.flutter.dev/flutter/material/AboutListTile-class.html
            icon: Icon(Icons.info_outline),
            // applicationIcon: ImageIcon(Image.asset("image/app_icon_android.png").image),
            aboutBoxChildren: [
              Text("An epilepsy daily app written in Flutter for Phramongkutklao Hospital's Pediatric Epilepsy Center.")
            ],
          ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.refresh),
          //   title: const Text('generateDummyData'),
          //   onTap: () {
          //     DatabaseService.generateDummyData(100,3);
          //   },
          // ),
          // We won't use this in production, ofc
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.refresh),
          //   title: const Text('Notification tests'),
          //   onTap: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => const NotificationTest()));
          //   },
          // ),
        ],
      ),
    );
  }
}
