import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/utils/strings.dart';

class RecordDatePage extends StatefulWidget {
  const RecordDatePage({Key? key}) : super(key: key);

  @override
  State<RecordDatePage> createState() => _RecordDateState();
}

class _RecordDateState extends State<RecordDatePage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_report,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        children: [
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () {},
              text: button_today,
              isDisabled: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () {},
              text: button_week,
              isDisabled: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () {},
              text: button_month,
              isDisabled: true,
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }
}
