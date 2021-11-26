import 'package:flutter/material.dart';
import 'package:notebook/Provider/theme.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class SelectButton extends StatefulWidget {
  const SelectButton({Key? key}) : super(key: key);

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  ToggleTheme inst = ToggleTheme();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btn1",
      backgroundColor:Provider.of<ToggleTheme>(context).isLightTheme? Colors.white: Colors.grey[850],
      onPressed: () {
        showPopover(context: context,
            bodyBuilder: (context)=>GestureDetector(
              onTap: (){
                Provider.of<ToggleTheme>(context, listen: false).toggleTheme();
                  print ('x');
                },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                height: 50.0,
                width: 200.0,
                color: Colors.white70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                        'Light Mode',
                    style: TextStyle(
                      color: Colors.grey[850],
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      fontSize: 19.0,
                    ),
                    ),
                    Icon(
                        Icons.circle,
                      color: Provider.of<ToggleTheme>(context).isLightTheme? Colors.yellowAccent : Colors.transparent,)
                  ],
                ),
              ),
            ));
      },
      child: Icon(
        Icons.settings,
        color: Colors.yellowAccent,
      ),
    );
  }
}
