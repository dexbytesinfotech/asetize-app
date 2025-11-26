import 'package:asetize/imports.dart';

class ImageLoader extends StatelessWidget {
  final double? loaderSize;
  final Color? loaderColor;
  const ImageLoader({Key? key, this.loaderSize, this.loaderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: loaderSize ?? 20,
            width: loaderSize ?? 20,
            child: CircularProgressIndicator(
              strokeWidth: 1.8,
              color: loaderColor ?? AppColors.textBlueColor,
            )));
  }
}
