import 'package:flutter/cupertino.dart';
import 'package:asetize/imports.dart';

class InputDoneView extends StatelessWidget {
  final onPressCallback, buttonType, buttonName;
  final TextStyle textStyle;
  InputDoneView(
      {Key? key,
      this.onPressCallback,
      this.buttonType,
      this.buttonName = "",
      this.textStyle =
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE0E0E0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: CupertinoButton(
            padding: const EdgeInsets.only(right: 24.0, top: 3.0, bottom: 3.0),
            onPressed: () {
              //FocusScope.of(context).requestFocus(new FocusNode());
              onPressCallback();
            },
            child: Text(buttonName, style: textStyle),
          ),
        ),
      ),
    );
  }
}
