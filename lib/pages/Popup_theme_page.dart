import 'package:flutter/material.dart';

class ThemeSelect extends StatelessWidget {
  const ThemeSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }
}
