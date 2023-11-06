import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MnBtn extends StatelessWidget {
  const MnBtn({Key? key, required this.press, required this.riveOnInit})
      : super(key: key);
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: press,
        child: Container(
            margin: EdgeInsets.only(left: 10),
            height: 40,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 3),
                  blurRadius: 8,
                )
              ],
            ),
            child: RiveAnimation.asset(
              "assets/rive_assets/menub.riv",
              onInit: riveOnInit,
            )),
      ),
    );
  }
}
