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

import 'dart:io';
import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/label_text_form_field.dart';
import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';
import 'package:epilepsy_care_pmk/helpers/image_utility.dart';
import 'package:epilepsy_care_pmk/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>(); // Validate
  TextEditingController birthDateFieldController = TextEditingController();  // Use to fill the input with the selected date
  /// This var will be used to determine whether to pushReplace,
  /// or popUntil after the user has click on the register button.
  late bool isFirstLaunch;

  // 2 different var here that represents an image. (must be separated because a file must have a path, and an Image object will not have a path)
  /// Image that is loaded from preference.
  Image? imageFromPreferences;
  /// Image that is selected from the image picker. Also contains path to that file.
  XFile? selectedImage;
  String? hn;
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  String? gender; // TODO: define type for gender

  @override
  void initState() {
    super.initState();

    hn = prefs.getString('hn');
    firstName = prefs.getString('firstName');
    lastName = prefs.getString('lastName');
    gender = prefs.getString('gender');

    String? birthDateTimestamp = prefs.getString('birthDate');
    if (birthDateTimestamp != null) {
      birthDate = DateTime.parse(birthDateTimestamp);
      birthDateFieldController.text = dateDateFormat.format(birthDate!);
    }

    String? imgString = prefs.getString("IMG_KEY");
    if (imgString != null) {
      imageFromPreferences = ImageUtility.imageFromBase64String(imgString);
    }

    isFirstLaunch = hn == null;  // If hn or any field is null for that matter, we know that the user haven't registered yet

    // A way to use async functions in init state is to use then, I guess
    // https://stackoverflow.com/questions/51901002/is-there-a-way-to-load-async-data-on-initstate-method
    // image avatar save
    // Utility.getImageFromPreferences().then((img) {
    //   if (img == null) {
    //     return;
    //   }
    //   imageFromPreferences = Utility.imageFromBase64String(img);
    // });
  }

  Future<void> register() async {
    prefs.setString('hn', hn!);
    prefs.setString('firstName', firstName!);
    prefs.setString('lastName', lastName!);
    prefs.setString('gender', gender!);
    prefs.setString('birthDate', birthDate!.toIso8601String());

    if (selectedImage != null) {
      ImageUtility.saveImageToPreferences(
          ImageUtility.base64String(await selectedImage!.readAsBytes()));
    } else {
      prefs.remove("IMG_KEY");
    }
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage =
    await ImagePicker().pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );

    if (returnedImage != null) {
      setState(() {
        selectedImage = returnedImage;
      });
    }
  }

  /// Clear any selectedImage and remove them from shared preference
  void _deleteImage() {
    setState(() {
      selectedImage = null;
      imageFromPreferences = null;
    });
    // prefs.remove("IMG_KEY");  // Do not remove here, since the user haven't saved the change yet.
  }

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            // For some reason, wrapping CircleAvatar with InkWell doesn't
                            // produce the ripple effect on tap.
                            // So we create a material child that will lay on top of the CircleAvatar
                            // which does have the ripple effect on tap
                            // https://github.com/flutter/flutter/issues/42901
                            children: [
                              CircleAvatar(
                                radius: 2 * kCircleRadius,
                                // backgroundImage: selectedImage == null
                                //     ? profilePlaceholder
                                //     : Image.file(File(selectedImage!.path))
                                //         .image, // For some reason, Image can't be assigned to ImageProvider, so we append ".image" to the Image widget (https://stackoverflow.com/questions/66561177/the-argument-type-object-cant-be-assigned-to-the-parameter-type-imageprovide)
                                backgroundImage: ((selectedImage != null) ? Image.file(File(selectedImage!.path)).image : null)
                                    ?? imageFromPreferences?.image ?? profilePlaceholder,
                                child: Material(
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => {_pickImageFromGallery()},
                                  ),
                                )
                              ),
                              SizedBox(width: kSmallPadding,),
                              (selectedImage != null || imageFromPreferences != null)
                                  ? ElevatedButton(onPressed: () => { _deleteImage() }, child: Text("ลบรูปภาพ"))
                                  : SizedBox.shrink(),
                            ]
                        ),
                        SizedBox(height: kSmallPadding),
                        LabelTextFormField(
                          label: "HN",
                          initialValue: hn,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'กรุณาระบุเลขประจำตัวผู้ป่วย';
                            }
                            return null;
                          },
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
                                  label: "ชื่อ",
                              initialValue: firstName,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'กรุณาระบุชื่อ';
                                }
                                return null;
                              },
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
                                  label: "นามสกุล",
                              initialValue: lastName,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'กรุณาระบุนามสกุล';
                                }
                                return null;
                              },
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
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_month_outlined)),
                          onTap: () async {
                            birthDate = await showDatePicker(
                                context: context,
                                initialDate: birthDate ?? DateTime.now(),
                                //get today's date
                                firstDate: beginEpoch,
                                lastDate: endDate
                            );  // TODO: decide on an end date
                            if (birthDate != null) {
                              birthDateFieldController.text =
                                  dateDateFormat.format(birthDate!);


                              // birthDateFieldController.text =
                              //     DateFormat.yMd(Localizations
                              //         .localeOf(context)
                              //         .languageCode).format(birthDate!);
                            }
                          },
                        ),
                        LabelTextFormField(
                          label: "เพศ",
                          initialValue: gender,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'กรุณาระบุเพศสภาพ';
                            }
                            return null;
                          },
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
                                register();

                                if (isFirstLaunch) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => const MyHomePage()));
                                } else {
                                  // TODO: Make the first page refresh with the new data
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                }
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
