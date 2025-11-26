import '../imports.dart';

class GradientTextView extends StatelessWidget {
  final List<Color>? linearGradientColors;
  final String title;
  final double? fontSize;
  final FontWeight? fontWeight;
  const GradientTextView(
      {super.key,
      this.linearGradientColors,
      required this.title,
      this.fontSize = 20,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: fontSize!,
            fontFamily: "Roboto",
            fontWeight: fontWeight ?? FontWeight.w500,
            //  foreground: Paint()..shader = linearGradient
            foreground: Paint()
              ..shader = LinearGradient(
                colors: linearGradientColors ??
                    const <Color>[
                      Color(0xffF7B500),
                      Color(0xffB620E0),
                      Color(0xff32C5FF)
                    ],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))));
  }
}
