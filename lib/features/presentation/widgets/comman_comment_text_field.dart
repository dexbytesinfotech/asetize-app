import 'package:cached_network_image/cached_network_image.dart';
import 'package:asetize/imports.dart';

class CommonCommentTextField extends StatefulWidget {
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final EdgeInsetsGeometry? imagePadding;
  const CommonCommentTextField(
      {Key? key, this.suffixIcon, this.margin, this.height, this.imagePadding})
      : super(key: key);

  @override
  State<CommonCommentTextField> createState() => _CommonCommentTextFieldState();
}

class _CommonCommentTextFieldState extends State<CommonCommentTextField> {
  Map<String, TextEditingController> controllers = {
    'comment': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'comment': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'comment': "",
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ??
          const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['comment'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['comment']?.toString() ?? '',
        controllerT: controllers['comment'],
        borderRadius: 8,
        inputHeight: widget.height ?? 50,
        errorLeftRightMargin: 0,
        maxCharLength: 250,
        errorMsgHeight: 0,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.sentences,
        cursorColor: Colors.grey,
        enabledBorderColor: AppColors.textFiledBorderColor,
        focusedBorderColor: AppColors.textFiledBorderColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.none,
        inputFieldPrefixIcon: Padding(
          padding: widget.imagePadding ?? const EdgeInsets.only(right: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: CachedNetworkImage(
                placeholder: (context, url) => const ImageLoader(),
                height: 30,
                width: 30,
                imageUrl:
                    "https://i.pinimg.com/222x/53/c0/4e/53c04e4fe03291050c4eabd5d73a5a3e.jpg",
                fit: BoxFit.cover,
                errorWidget: (
                  BuildContext context,
                  String url,
                  Object error,
                ) {
                  return Container(color: Colors.grey);
                }),
          ),
        ),
        inputFieldSuffixIcon: widget.suffixIcon,
        inputKeyboardType: InputKeyboardTypeWithError.email,
        hintText: "Write a comment",
        hintStyle: appStyles.hintTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            texColor: const Color(0xFF575757)),
        textStyle: appStyles.textFieldTextStyle(
            texColor: Colors.black87, fontWeight: FontWeight.w400),
        contentPadding:
            const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 18),
        onTextChange: (value) {
          // checkEmail(value, 'email', onchange: true);
        },
        onEndEditing: (value) {
          // checkEmail(value, 'email');
          FocusScope.of(context).requestFocus(focusNodes['password']);
        },
      ),
    );
  }
}
