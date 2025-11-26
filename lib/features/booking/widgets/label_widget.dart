
import '../../../imports.dart';

class LabelWidget extends StatelessWidget {
  final String labelText;
  final bool isRequired;
  const LabelWidget({
    super.key,
    required this.labelText,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3.0, bottom: 5),
          child:
              isRequired
                  ? Text.rich(
                    TextSpan(
                      text: labelText,
                      style: appStyles.texFieldPlaceHolderStyle(),
                      children: [
                        TextSpan(
                          text: ' *', // Asterisk
                          style: appStyles.texFieldPlaceHolderStyle().copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  )
                  : Text(
                    labelText,
                    style: appStyles.texFieldPlaceHolderStyle(),
                  ),
        ),
      ],
    );
  }
}
