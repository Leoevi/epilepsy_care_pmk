import 'package:flutter/material.dart';

class Wiki extends StatelessWidget {
  const Wiki({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),  // TODO: declare this as a global thing where other screens can use the same value
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              width: 256,
              height: 100,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1E000000),
                    blurRadius: 40,
                    offset: Offset(0, 8),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Text("placeholder for logo (size unknown)")
            ),
          ),
          Expanded(  // Wrap LayoutBuilder with Expanded in order to assign flex value to it
            child: LayoutBuilder(builder: (context, constraints) {  // From https://docs.flutter.dev/cookbook/lists/spaced-items
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),  // LayoutBuilder must have a flex; otherwise, constraints.maxHeight will be Infinity
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ItemWidget(text: 'Item 1'),
                      ItemWidget(text: 'Item 2'),
                      // ItemWidget(text: 'Item 3'),
                      // ItemWidget(text: 'Item 3'),
                      // ItemWidget(text: 'Item 3'),
                      // ItemWidget(text: 'Item 3'),
                      // ItemWidget(text: 'Item 3'),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(child: Text(text)),
      ),
    );
  }
}