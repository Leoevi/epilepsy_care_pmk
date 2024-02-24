import 'dart:io';

import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/label_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  XFile? selectedImage;
  int? hn;
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  var gender;  // TODO: define type for gender

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
                        Text("ลงทะเบียนข้อมูล", style: Theme.of(context).textTheme.titleLarge,),

                        SizedBox(height: kLargePadding,),

                        Center(
                            // For some reason, wrapping CircleAvatar with InkWell doesn't
                            // produce the ripple effect on tap.
                            // So we create a material child that will lay on top of the CircleAvatar
                            // which does have the ripple effect on tap
                            // https://github.com/flutter/flutter/issues/42901
                            child: CircleAvatar(
                                radius: 2*kCircleRadius,
                                backgroundImage: selectedImage == null ? profilePlaceholder : Image.file(File(selectedImage!.path)).image,  // For some reason, Image can't be assigned to ImageProvider, so we append ".image" to the Image widget (https://stackoverflow.com/questions/66561177/the-argument-type-object-cant-be-assigned-to-the-parameter-type-imageprovide)
                                child: Material(
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => { _pickImageFromGallery() },
                                  ),
                                ))),

                        SizedBox(height: kSmallPadding),

                        LabelTextFormField(label: "HN"),

                        Row(
                          children: [
                            Expanded(child: LabelTextFormField(label: "ชื่อจริง")),
                            SizedBox(width: kMediumPadding,),
                            Expanded(child: LabelTextFormField(label: "นามสกุล")),
                          ],
                        ),

                        Text("วันเกิด", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          controller: birthDateFieldController,
                          decoration: InputDecoration(
                              // hintText: selectedTime.format(context),
                              border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_month_outlined)
                          ),
                          onTap: () async {
                            birthDate = await showDatePicker(
                                context: context,
                                initialDate: birthDate ?? DateTime.now(),
                                //get today's date
                                firstDate: DateTime(1980, 1, 1),
                                lastDate: DateTime(2101, 12, 31));

                            if (birthDate != null) {
                              birthDateFieldController.text = dateDateFormat.format(birthDate!);
                              // TODO: instead of formatting manually like so, we can detect localization; however, this requires setting localization for the whole app
                              // birthDateFieldController.text =
                              //     DateFormat.yMd(Localizations
                              //         .localeOf(context)
                              //         .languageCode).format(birthDate!);
                            }
                          },
                        ),

                        LabelTextFormField(label: "เพศ"),

                        SizedBox(height: kMediumPadding),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            child: Text("ลงทะเบียน",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            onPressed: () {
                              //validate check
                              if (_formKey.currentState!.validate()) {
                                printAll();  // TODO: remove this if not needed
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              }
                            },
                            style: primaryButtonStyle,
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
