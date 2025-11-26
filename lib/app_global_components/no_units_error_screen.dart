import '../core/util/app_theme/text_style.dart';
import '../imports.dart';

class NoUnitsErrorScreen extends StatelessWidget {
  final String? title;
  final String? message;
  const NoUnitsErrorScreen({super.key,this.title = "No Units Available",this.message ="You currently don\'t have any units assigned."});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.apartment,
            size: 50,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            '$title',
            style: appTextStyle.appTitleStyle(),
          ),
          const SizedBox(height: 8),
          Text(
            '$message',
            style: appTextStyle.appSubTitleStyle(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
