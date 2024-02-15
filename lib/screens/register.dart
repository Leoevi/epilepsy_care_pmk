import 'dart:io';

import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/label_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>(); // Validate
  XFile? _selectedImage;

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = returnedImage;
    });
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
                        Text("ลงทะเบียนข้อมูล"),

                        Center(
                            // For some reason, wrapping CircleAvatar with InkWell doesn't
                            // produce the ripple effect on tap.
                            // So we create a material child that will lay on top of the CircleAvatar
                            // which does have the ripple effect on tap
                            // https://github.com/flutter/flutter/issues/42901
                            child: CircleAvatar(
                                radius: kCircleRadius,
                                backgroundImage: _selectedImage == null ? null : Image.file(File(_selectedImage!.path)).image,  // For some reason, Image can't be assigned to ImageProvider, so we append ".image" to the Image widget (https://stackoverflow.com/questions/66561177/the-argument-type-object-cant-be-assigned-to-the-parameter-type-imageprovide)
                                child: Material(
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => { _pickImageFromGallery() },
                                  ),
                                ))),

                        LabelTextFormField(label: "HN"),

                        LabelTextFormField(label: "HN"),

                        Text("วันเกิด", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              // hintText: selectedTime.format(context),
                              border: OutlineInputBorder()),
                        ),

                        LabelTextFormField(label: "HN"),
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
