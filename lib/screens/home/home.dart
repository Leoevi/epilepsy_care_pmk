import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
          child: Column(children: <Widget>[
            Text(
              "This is Home",
              style: TextStyle(
                color: Colors.green[900],
                fontSize: 45,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    //get today's date
                    firstDate: DateTime(2000),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));
              },
              child: Text("Date Picker"),
            )
          ])),
    );
  }
}