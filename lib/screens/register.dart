// MIT License
//
// Copyright (c) 2024 Krittapong Kijchaiyaporn, Piyathat Chimpon, Pantira Chinsuwan, Wilawan W.Wilodjananunt, Dittaya Wanvarie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:convert';
import 'dart:io';
import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/label_text_form_field.dart';
import 'package:epilepsy_care_pmk/helpers/utility.dart';
import 'package:epilepsy_care_pmk/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Image? imageFromPreferences;
  XFile? selectedImage;
  String? hn;
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  String? birthDateTimeStamp;
  String? gender; // TODO: define type for gender

  // Future<void> loadFirstLaunch() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _isFirstLaunch = prefs.getBool('first_launch') ?? true;
  //     if (_isFirstLaunch) {
  //       prefs.setBool('first_launch', false);
  //     }
  //   });
  // }

  @override
  void initState() {
    // loadFirstLaunch();
    loadData();
    super.initState();
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hn = prefs.getString('hn') ?? null;
      firstName = prefs.getString('firstName') ?? null;
      lastName = prefs.getString('lastName') ?? null;
      gender = prefs.getString('gender') ?? null;
      birthDateTimeStamp = prefs.getString('birthDate') ?? null;
      //selectedImage = prefs.get('selectedImage') as XFile;

      //image avatar save
      Utility.getImageFromPreferences().then((img) {
        if (null == img) {
          return;
        }
        imageFromPreferences = Utility.imageFromBase64String(img);
      });
    });
  }

  Future<void> register() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('hn', hn!);
    prefs.setString('firstName', firstName!);
    prefs.setString('lastName', lastName!);
    prefs.setString('gender', gender!);

    //birthDate save
    birthDateTimeStamp = birthDate!.toIso8601String();
    print("BD val : $birthDateTimeStamp");
    prefs.setString('birthDate', birthDateTimeStamp!);
  }

  void printAll() {
    print("hn: $hn");
    print("firstName: $firstName");
    print("lastName: $lastName");
    print("birthDate: $birthDate");
    print("gender: $gender");
  }

  final _formKey = GlobalKey<FormState>(); // Validate

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null) {
      setState(() {
        selectedImage = returnedImage;
      });
      Utility.saveImageToPreferences(
          Utility.base64String(await returnedImage.readAsBytes() as Uint8List));
    }
  }

  var birthDateFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: splashBackgroundDecoration,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(2 * kLargePadding),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(kLargePadding),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey, // validate
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ลงทะเบียนข้อมูล",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: kLargePadding,
                        ),
                        Center(
                            // For some reason, wrapping CircleAvatar with InkWell doesn't
                            // produce the ripple effect on tap.
                            // So we create a material child that will lay on top of the CircleAvatar
                            // which does have the ripple effect on tap
                            // https://github.com/flutter/flutter/issues/42901
                            child: CircleAvatar(
                                radius: 2 * kCircleRadius,
                                backgroundImage: selectedImage == null
                                    ? profilePlaceholder
                                    : Image.file(File(selectedImage!.path))
                                        .image, // For some reason, Image can't be assigned to ImageProvider, so we append ".image" to the Image widget (https://stackoverflow.com/questions/66561177/the-argument-type-object-cant-be-assigned-to-the-parameter-type-imageprovide)
                                child: Material(
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => {_pickImageFromGallery()},
                                  ),
                                ))),
                        SizedBox(height: kSmallPadding),
                        LabelTextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'กรุณาระบุเลขประจำตัวผู้ป่วย';
                            }
                            return null;
                          },
                          label: "HN",
                          onChanged: (String hnValue) {
                            setState(() {
                              hn = hnValue; //retieve input value to hn
                            });
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: LabelTextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'กรุณาระบุชื่อ';
                                }
                                return null;
                              },
                              label: "ชื่อ",
                              onChanged: (String firstNameValue) {
                                //async
                                // final SharedPreferences prefs =
                                //     await SharedPreferences.getInstance();
                                setState(() {
                                  firstName =
                                      firstNameValue; //retieve input value to firstName
                                });
                              },
                            )),
                            SizedBox(
                              width: kMediumPadding,
                            ),
                            Expanded(
                                child: LabelTextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'กรุณาระบุนามสกุล';
                                }
                                return null;
                              },
                              label: "นามสกุล",
                              onChanged: (String lastNameValue) {
                                //async
                                //  final SharedPreferences prefs =
                                //     await SharedPreferences.getInstance();
                                setState(() {
                                  lastName =
                                      lastNameValue; //retieve input value to lastName
                                  // prefs.setString('lastName', lastName!);
                                });
                              },
                            )),
                          ],
                        ),
                        Text("วันเกิด", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'กรุณาระบุวันเกิดของผู้ป่วย';
                            }
                            return null;
                          },
                          readOnly: true,
                          controller: birthDateFieldController,
                          decoration: InputDecoration(
                              // hintText: selectedTime.format(context),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_month_outlined)),
                          onTap: () async {
                            birthDate = await showDatePicker(
                                context: context,
                                initialDate: birthDate ?? DateTime.now(),
                                //get today's date
                                firstDate: DateTime(1980, 1, 1),
                                lastDate: DateTime(2101, 12, 31));

                            if (birthDate != null) {
                              birthDateFieldController.text =
                                  dateDateFormat.format(birthDate!);

                              // TODO: instead of formatting manually like so, we can detect localization; however, this requires setting localization for the whole app
                              // birthDateFieldController.text =
                              //     DateFormat.yMd(Localizations
                              //         .localeOf(context)
                              //         .languageCode).format(birthDate!);
                            }
                          },
                        ),
                        LabelTextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'กรุณาระบุเพศสภาพ';
                            }
                            return null;
                          },
                          label: "เพศ",
                          onChanged: (String genderValue) {
                            //async
                            // final SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            setState(() {
                              gender = genderValue; //load input to hn
                              // prefs.setString('gender', gender!);
                            });
                          },
                        ),
                        SizedBox(height: kMediumPadding),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            child: Text("ลงทะเบียน",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            onPressed: () async {
                              //validate check
                              if (_formKey.currentState!.validate()) {
                                // _isRegister = true;
                                printAll(); // TODO: remove this if not needed
                                register();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context)=> const MyHomePage(title: 'Epilepsy Care')));
                                // Navigator.of(context)
                                //     .popUntil((route) => route.isFirst);
                              }
                            },
                            style: primaryButtonStyle,
                          ),
                        ),
                        //Prefs saved value check
                        // Text("HN: $hn"),
                        // Text("FirstName: $firstName"),
                        // Text("LastName: $lastName"),
                        // Text("gender: $gender"),
                        // Text("Birth: $birthDateTimeStamp"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ))),
    );
  }
}
