import 'package:epilepsy_care_pmk/custom_widgets/column_with_spacings.dart';
import 'package:epilepsy_care_pmk/screens/commons/page_with_header_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/styling.dart';

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
                const Row(
                  children: [
                    Icon(Icons.headset_mic_outlined, size: kCircleRadius*2,),
                    SizedBox(
                      width: kMediumPadding,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ช่องทางการติดต่อ", style: mediumLargeBoldText,),
                          Text(
                              "หน่วยประสาทวิทยา กองกุมารเวขกรรมรพ. พระมงกุฎเกล้า"),
                        ],
                      ),
                    ),
                  ],
                ),

                // TODO: check if all of these contact address is up-to-date
                ContactEntry(
                  label: "เว็บไซต์",
                  address: "https://www.pedpmk.org/",
                  buttonLabel: "เข้าเว็บไซต์",
                  onPressed: () async {
                    final httpUri = Uri(
                      scheme: "https",
                      host: "www.pedpmk.org",
                    );
                    if (await canLaunchUrl(httpUri)) {
                      launchUrl(httpUri);
                    }
                  },
                ),
                ContactEntry(
                  label: "อีเมล์",
                  address: "pediatricneurologypmk@gmail.com",
                  buttonLabel: "ส่งอีเมล์",
                  onPressed: () async {
                    final callUri = Uri(
                      scheme: "mailto",
                      path: "pediatricneurologypmk@gmail.com",
                    );
                    if (await canLaunchUrl(callUri)) {
                      launchUrl(callUri);
                    }
                  },
                ),
                ContactEntry(
                  label: "เบอร์โทร",
                  address: "098-523-3838",
                  buttonLabel: "โทร",
                  onPressed: () async {
                    final callUri = Uri(
                      scheme: "tel",
                      path: "098-523-3838",
                    );
                    if (await canLaunchUrl(callUri)) {
                      launchUrl(callUri);
                    }
                  },
                ),
                ContactEntry(
                  label: "LINE ID",
                  address: "0985233838",
                  buttonLabel: "ไปที่ LINE",
                  onPressed: () async {
                    final callUri = Uri(
                      scheme: "https",
                      path: "line.me/ti/p/IIIhyX3yUF",
                    );
                    if (await canLaunchUrl(callUri)) {
                      launchUrl(callUri);
                    }
                  },  // TODO: make the button launch the LINE app
                ),
              ],
            ),
          )),
    );
  }
}

class ContactEntry extends StatelessWidget {
  const ContactEntry({
    super.key,
    required this.label,
    required this.address,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String label;
  final String address;
  final String buttonLabel;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label, style: mediumLargeBoldText,),
            IconButton(
              icon: const Icon(Icons.copy),
              visualDensity: VisualDensity.compact,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: address));
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(address)),
            // Wrap with expanded so that it can wrap to a newline instead of overflowing
            ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ],
    );
  }
}
