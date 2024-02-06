import 'package:epilepsy_care_pmk/custom_widgets/column_with_spacings.dart';
import 'package:epilepsy_care_pmk/screens/commons/page_with_header_logo.dart';
import 'package:flutter/material.dart';

import '../../constants/padding_values.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLogo(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kMediumRoundedCornerRadius)),
        child: Padding(
          padding: const EdgeInsets.all(kMediumPadding),
          child: ColumnWithSpacings(
            children: [
              Row(
                children: [
                  Icon(Icons.headset_mic_outlined),
                  const SizedBox(
                    width: kMediumPadding,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ช่องทางการติดต่อ"),
                        Text("หน่วยประสาทวิทยา กองกุมารเวขกรรมรพ. พระมงกุฎเกล้า"),
                      ],
                    ),
                  ),
                ],
              ),
              ContactEntry(label: "เว็บไซต์", address: "http://www.pedceppmk.com/", buttonLabel: "เข้าเว็บไซต์"),
              ContactEntry(label: "อีเมล์", address: "pediatricneurologypmk@gmail.com", buttonLabel: "ส่งอีเมล์"),
              ContactEntry(label: "เบอร์โทร", address: "098-523-3838", buttonLabel: "โทร"),
              ContactEntry(label: "LINE ID", address: "0985233838", buttonLabel: "ไปที่ LINE"),
            ],
          ),
        )
      ),
    );
  }
}

class ContactEntry extends StatelessWidget {
  const ContactEntry({
    super.key,
    required this.label,
    required this.address,
    required this.buttonLabel,
  });

  final String label;
  final String address;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label),
            SizedBox(width: kSmallPadding),
            Icon(Icons.copy),  // TODO: make the copy button functional
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(address)),  // Wrap with expanded so that it can wrap to a newline instead of overflowing
            ElevatedButton(
              onPressed: () {},
              child: Text(buttonLabel),
            )
          ],
        ),
      ],
    );
  }
}
