// MIT License
//
// Copyright (c) 2024 Krittapong Kijchaiyaporn, Piyathat Chimpon, Piradee Suwanpakdee, Wilawan W.Wilodjananunt, Dittaya Wanvarie
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
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/user_profile_service.dart';
import 'main_page.dart';

const List<String> genders = <String>['ชาย', 'หญิง', 'อื่น ๆ'];

/// Register page where it will launch if the user hasn't registered with their
/// info yet. But can also be used to edit the user current information.
/// Generally, this will be the only page to call [UserProfileService.saveToPref]
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
  bool isRegistered = UserProfileService().isRegistered;
  /// Will be used to resize profile picture. (So that it will scale to the
  /// screen resolution).
  late double devicePixelRatio;

  // These vars will mostly reflect each fields in UserProfileService, and they
  // will be loaded from that same class.
  // 2 different var here that represents an image. (must be separated because a file must have a path, and an Image object will not have a path)
  /// Image that is loaded from preference.
  Image? imageFromPreferences;
  /// Image that is selected from the image picker. Also contains path to that file.
  XFile? selectedImage;
  String? hn;
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  String? gender;

  /// Load data from shared preference if it exists.
  @override
  void initState() {
    super.initState();

    if (UserProfileService().isRegistered) {
      imageFromPreferences = UserProfileService().image;
      hn = UserProfileService().hn;
      firstName = UserProfileService().firstName;
      lastName = UserProfileService().lastName;
      gender = UserProfileService().gender;
      birthDate = UserProfileService().birthDate;
      if (birthDate != null) {
        birthDateFieldController.text = DateFormat.yMMMd(locale).format(birthDate!);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      devicePixelRatio = View.of(context).devicePixelRatio;
    });
  }

  @override
  void dispose() {
    birthDateFieldController.dispose();
    super.dispose();
  }

  Future<void> register(UserProfileService model) async {
    model.saveToPref(hn!, firstName!, lastName!, birthDate!, gender!);

    if (selectedImage != null) {  // A new image is selected
      // Overwrite with new image
      await model.saveImage(selectedImage!);
    } else if (imageFromPreferences == null) {  // Old image was cleared
      model.clearImage();
    }
  }

  /// Pick an image from the device and also resizing it to an appropriate size
  /// according to the device's screen resolution.
  Future<void> _pickImageFromGallery() async {
    final returnedImage =
    await ImagePicker().pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,  // This somehow fixed iOS double image picker problem.
        // This will resize the image automatically.
      maxHeight: 128*devicePixelRatio,
      maxWidth: 128*devicePixelRatio
    );

    if (returnedImage != null) {
      setState(() {
        selectedImage = returnedImage;
      });
    }
  }

  /// Clear any selectedImage and remove them from shared preference.
  /// Not to be confused with [UserProfileService.clearImage]. This method only
  /// clears the image "in this screen", but not from shared preference.
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
                        const SizedBox(
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
                              const SizedBox(width: kSmallPadding,),
                              (selectedImage != null || imageFromPreferences != null)
                                  ? ElevatedButton(onPressed: () => { _deleteImage() }, child: const Text("ลบรูปภาพ"))
                                  : const SizedBox.shrink(),
                            ]
                        ),
                        const SizedBox(height: kSmallPadding),
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
                                setState(() {
                                  firstName =
                                      firstNameValue; //retieve input value to firstName
                                });
                              },
                            )),
                            const SizedBox(
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
                                setState(() {
                                  lastName =
                                      lastNameValue; //retieve input value to lastName
                                  // prefs.setString('lastName', lastName!);
                                });
                              },
                            )),
                          ],
                        ),
                        const Text("วันเกิด", style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'กรุณาระบุวันเกิดของผู้ป่วย';
                            }
                            return null;
                          },
                          readOnly: true,
                          controller: birthDateFieldController,
                          decoration: const InputDecoration(
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
                                  DateFormat.yMMMd(locale).format(birthDate!);


                              // birthDateFieldController.text =
                              //     DateFormat.yMd(Localizations
                              //         .localeOf(context)
                              //         .languageCode).format(birthDate!);
                            }
                          },
                        ),
                        const Text("เพศ", style: TextStyle(fontSize: 18),),
                        const SizedBox(height: kSmallPadding),
                        DropdownButtonFormField<String>(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'กรุณาระบุเพศสภาพ';
                            }
                            return null;
                          },
                          value: gender,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                          onChanged: (String? val) {
                            setState(() {
                              gender = val!;
                            });
                          },
                          items: genders
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: kMediumPadding),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Consumer<UserProfileService>(
                              builder: (context, model, child) => ElevatedButton(
                                onPressed: () async {
                                  //validate check
                                  if (_formKey.currentState!.validate()) {
                                    final navigator = Navigator.of(context);
                                    await register(model);

                                    // If you are going to use context after awaiting, don't forget to check mounted property.
                                    // https://dart.dev/tools/linter-rules/use_build_context_synchronously
                                    // if (!context.mounted) return;
                                    // However, this still caused onboarding to not show on some circumstances.
                                    // Or alternatively, use context to create a navigator before awaiting
                                    // (https://stackoverflow.com/a/69512692)

                                    if (!isRegistered) {  // Note that we didn't use the value from the model since by calling saveToPref, model.isRegistered will always be true
                                      navigator.pushReplacement(MaterialPageRoute(builder: (context) => const MainPage(doOnboarding: true,)));
                                      // Navigator.pushReplacement(context,
                                      //     MaterialPageRoute(builder: (context) => const MainPage(doOnboarding: true,)));
                                    } else {
                                      navigator.pop();
                                      // Navigator.pop(context);
                                    }
                                  }
                                },
                                style: primaryButtonStyle,
                                child: const Text("ลงทะเบียน",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                          ),
                        ),
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
