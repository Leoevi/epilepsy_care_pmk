import 'dart:io';

import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  XFile? selectedImage;
  int? hn;
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  var gender;

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null) {
      setState(() {
        selectedImage = returnedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
        title: 'ข้อมูลส่วนตัว',
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
                //from register.dart
                child: CircleAvatar(
                    radius: 2 * kCircleRadius,
                    backgroundImage: selectedImage == null
                        ? profilePlaceholder
                        : Image.file(File(selectedImage!.path)).image,
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => {_pickImageFromGallery()},
                      ),
                    ))),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                width: double.infinity, //make width container has full length
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Padding(
                  padding: EdgeInsets.all(kLargePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("ข้อมูลเบื้องต้น"),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.info,
                            color: Color(0xff1C7D9C),
                          ),
                          SizedBox(
                            width: 200,
                          ),
                          IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {},
                              icon: Icon(Icons.edit_outlined)),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("HN : 12345"), //int? hn;
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "ชื่อ-นามสกุล : FirstName Surename"), //String? firstName; String? lastName;
                      SizedBox(
                        height: 10,
                      ),
                      Text("วันเกิด : 08/06/2544"), //DateTime? birthDate;
                      SizedBox(
                        height: 10,
                      ),
                      Text("เพศ : ชาย"), //var gender;
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
