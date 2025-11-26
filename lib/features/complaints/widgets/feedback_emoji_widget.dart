import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_emoji_feedback/gen/assets.gen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../presentation/widgets/app_button_common.dart';
import '../../presentation/widgets/workplace_widgets.dart';

class FeedbackEmojiWidget extends StatefulWidget {
  const FeedbackEmojiWidget({Key? key}) : super(key: key);

  @override
  State<FeedbackEmojiWidget> createState() => _FeedbackEmojiWidgetState();
}

class _FeedbackEmojiWidgetState extends State<FeedbackEmojiWidget> {
  int? rating;
  List<EmojiModel> emojiList = [
    //  EmojiModel(
    //   src: Assets.hdBad,
    //   label: 'Dissatisfied',
    //   package: 'flutter_emoji_feedback',
    // ),
    //  EmojiModel(
    //   src: Assets.hdVeryGood,
    //   label: 'Okay',
    //   package: 'flutter_emoji_feedback',
    // ),
    //  EmojiModel(
    //   src: Assets.hdAwesome,
    //   label: 'Satisfied',
    //   package: 'flutter_emoji_feedback',
    // ),
    const EmojiModel(
      src: Assets.classicBad,
      label: 'Dissatisfied',
      package: 'flutter_emoji_feedback',
    ),

    const EmojiModel(
      src: Assets.classicVeryGood,
      label: 'Okay',
      package: 'flutter_emoji_feedback',
    ),
    const EmojiModel(
      src: Assets.classicAwesome,
      label: 'Satisfied',
      package: 'flutter_emoji_feedback',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "How do you feel about our service?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          EmojiFeedback(
            //rating: rating,
            emojiPreset: notoAnimatedEmojis,
            inactiveElementBlendColor: Colors.grey,
            elementSize: 50,
            labelTextStyle: const TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 16),
           // Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 16),
            onChanged: (value) {
              setState(() => rating = value
              );
              debugPrint("feedback value : $rating");
            },
          ),
          const SizedBox(height: 20),
          if (rating != null)
            AppButton(
              buttonName: "Submit Feedback",
              backCallback: () {
                Navigator.of(context).pop();
                WorkplaceWidgets.successToast('Thank you for your feedback',durationInSeconds: 1);
              },
            ),

        ],
      ),
    );
  }
}
