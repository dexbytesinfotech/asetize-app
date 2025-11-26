import '../core/util/app_theme/text_style.dart';
import '../imports.dart';

class CommonSearchBar extends StatelessWidget {
  final void Function(String)? onChangeTextCallBack;
  final void Function()? onClickCrossCallBack;
  final void Function()? onClickScannerCallBack;
  final TextEditingController controller;
  final String? hintText;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isShowScannerIcon; // <-- control scanner visibility

  const CommonSearchBar({
    super.key,
    this.onChangeTextCallBack,
    required this.controller,
    this.hintText,
    this.onClickCrossCallBack,
    this.onClickScannerCallBack,
    this.padding,
    this.margin,
    this.isShowScannerIcon = false, // <-- default: hidden
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(top: 5, bottom: 0),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 19),
      height: 50,
      color: const Color(0xFFF5F5F5),
      child: TextField(
        controller: controller,
        onChanged: onChangeTextCallBack,
        style: appTextStyle.appNormalSmallTextStyle(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 0.4, color: Colors.grey.shade500),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 0.4, color: Colors.grey.shade500),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 0.4, color: Colors.grey.shade500),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText ?? AppString.searchHelper,
          prefixIcon: const Icon(Icons.search),

          // ✅ Handle both cross and scanner icons
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cross icon - only when text is not empty
              if (controller.text.isNotEmpty)
                IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/images/cross_icon.svg',
                      width: 18, // optional
                      height: 18,
                    ),
                  ),
                  onPressed: onClickCrossCallBack,
                ),

              // Scanner icon - only when enabled
              if (isShowScannerIcon)
                IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.all(6), // reduce padding for larger visual size
                    child: Image.asset(
                      'assets/images/barcode-scan.png',
                      width: 28, // ✅ increase width
                      height: 28, // ✅ increase height
                    ),
                  ),
                  onPressed: onClickScannerCallBack,
                ),
            ],
          ),


          contentPadding: const EdgeInsets.only(top: 0),
        ),
      ),
    );
  }
}
