import 'package:epilepsy_care_pmk/helpers/image_utility.dart';
import 'package:epilepsy_care_pmk/services/user_profile_service.dart';
import 'package:intl/intl.dart';
import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Image? imageFromPreferences;
  String? hn;
  String? firstName;
  String? lastName;
  String? gender;
  DateTime? birthDateTimeStampParse;
  String? birthDateString;

  @override
  void initState() {
    super.initState();
    hn = prefs.getString('hn');
    firstName = prefs.getString('firstName');
    lastName = prefs.getString('lastName');
    gender = prefs.getString('gender');

    String? birthDateTimestamp = prefs.getString('birthDate');
    if (birthDateTimestamp != null) {
      DateTime birthDate = DateTime.parse(birthDateTimestamp);
      birthDateString = DateFormat.yMMMd(locale).format(birthDate);
    }

    String? imgString = prefs.getString("IMG_KEY");
    if (imgString != null) {
      imageFromPreferences = ImageUtility.imageFromBase64String(imgString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
        title: 'ข้อมูลส่วนตัว',
        body: Consumer<UserProfileService>(
            builder: (context, model, child) => Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  //from register.dart
                    child: CircleAvatar(
                        radius: 2 * kCircleRadius,
                        backgroundImage: model.image?.image ?? profilePlaceholder, //image from register
                        child: const Material(
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                        ))),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity, //make width container has full length
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(kLargePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("ข้อมูลเบื้องต้น"),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.info,
                                color: Color(0xff1C7D9C),
                              ),
                              const Spacer(),
                              IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const Register()));
                                  },
                                  icon: const Icon(Icons.edit_outlined)),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text("HN : ${model.hn} "), //int? hn;
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              "ชื่อ-นามสกุล : ${model.firstName} ${model.lastName}"), //String? firstName; String? lastName;
                          const SizedBox(
                            height: 10,
                          ),
                          // TODO: replace with model
                          Text("วันเกิด : $birthDateString"), //DateTime? birthDate;
                          const SizedBox(
                            height: 10,
                          ),
                          Text("เพศ : ${model.gender}"), //var gender;
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
        ),
    );
  }
}
