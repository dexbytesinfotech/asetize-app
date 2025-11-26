import 'package:flutter/cupertino.dart';

import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_fonts.dart';
import '../../../imports.dart';

enum InputKeyboardTypeWithError {
  email,
  phone,
  text,
  password,
  number,
  multiLine,
  numberWithDecimal
}

enum CapitalizationText {
  /// Defaults to an uppercase keyboard for the first letter of each word.
  ///
  /// Corresponds to `InputType.TYPE_TEXT_FLAG_CAP_WORDS` on Android, and
  /// `UITextAutocapitalizationTypeWords` on iOS.
  words,

  /// Defaults to an uppercase keyboard for the first letter of each sentence.
  ///
  /// Corresponds to `InputType.TYPE_TEXT_FLAG_CAP_SENTENCES` on Android, and
  /// `UITextAutocapitalizationTypeSentences` on iOS.
  sentences,

  /// Defaults to an uppercase keyboard for each character.
  ///
  /// Corresponds to `InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS` on Android, and
  /// `UITextAutocapitalizationTypeAllCharacters` on iOS.
  characters,

  /// Defaults to a lowercase keyboard.
  none,
}

class CommonTextFieldWithError extends StatefulWidget {
  const CommonTextFieldWithError(
      {super.key,
        this.controllerT,
        this.errorMsgHeight,
        this.maxLines = 1, //set maximum lines in text field
        this.minLines = 1, //set maximum lines in text field
        this.maxCharLength = 50, // set maximum characters in text field
        this.inputHeight = 40, // set the height of a text field
        this.borderRadius = 10, // set border radius of text field
        this.hintText =
        'Enter some text...', // set place holder text in text field
        this.labelText = '', // set the label text in text field
        this.errorText = 'Please enter text', // set error text
        this.errorStyle, // set error text color
        this.enabledBorderColor = const Color(0xFFEEEEEE), // set enabled border color of a text field
        this.focusedBorderColor = AppColors.appBlueColor, // set focused border color of a text field
        this.errorBorderColor = Colors.transparent, // set focused border color of a text field
        this.backgroundColor, // set background border color of a text field
        this.inputKeyboardType = InputKeyboardTypeWithError
            .text, // set keyboard type of a text field // 1 = emailAddress, 2 = phone and 3 = text
        this.labelStyle, // set text color of a text field
        this.textStyle, // set text color of a text field
        this.hintStyle, // set text color of a text field
        @required this.onTextChange, // set the onChange function call back
        @required this.onEndEditing, // set the onSubmitted function call back
        this.showError = false,
        this.autoFocus = false,
        this.displayKeyBordDone = false,
        this.focusNode,
        this.placeHolderEdgeInsets,
        this.focusedBorderWidth,
        this.inputFieldPrefixText,
        this.enabledBorderWidth,
        this.inputFieldSuffixIcon,
        this.inputFieldPrefixIcon,
        this.prefixSuffixIconSiz,
        this.cursorColor,
        this.placeHolderTextWidget,
        this.onTapCallBack,
        this.isTextFieldEnabled = true,
        this.readOnly = false,
        this.showCounterText = false,
        this.textAlignment,
        this.textAlignmentVertical,
        this.contentPadding,
        this.inputFormatter,
        this.obscureText = false,
        this.isShowBottomErrorMsg = false,
        this.isShowShadow = false,
        this.errorMessages = "",
        this.errorMessageStyle,
        this.capitalization = CapitalizationText.sentences,
        this.errorLeftRightMargin = 12,
        this.textInputAction,
        this.lable,
        this.borderStyle,
        this.floatingLabelBehavior});

  final CapitalizationText capitalization;
  final bool showError;
  final bool autoFocus;
  final bool obscureText;
  final bool showCounterText;
  final double inputHeight;
  final double borderRadius;
  final int maxLines;
  final int minLines;
  final int maxCharLength;
  final double? focusedBorderWidth;
  final double? enabledBorderWidth;
  final double? errorMsgHeight;
  final String hintText;
  final String labelText;
  final Color enabledBorderColor;
  final Color? errorBorderColor;
  final Color? focusedBorderColor;
  final Color? backgroundColor;
  final Color? cursorColor;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final InputKeyboardTypeWithError inputKeyboardType;
  final EdgeInsets? placeHolderEdgeInsets;
  final ValueChanged? onTextChange;
  final ValueChanged? onEndEditing;
  final FocusNode? focusNode;
  final TextEditingController? controllerT;
  final inputFieldSuffixIcon;
  final inputFieldPrefixIcon;
  final inputFieldPrefixText;
  final Size? prefixSuffixIconSiz;
  final Widget? placeHolderTextWidget;
  final GestureTapCallback? onTapCallBack;
  final bool isTextFieldEnabled;
  final bool readOnly;
  final bool? displayKeyBordDone;
  final TextAlign? textAlignment;
  final TextAlignVertical? textAlignmentVertical;
  final contentPadding;
  final inputFormatter;
  final TextInputAction? textInputAction;
  final bool isShowBottomErrorMsg;
  final bool isShowShadow;
  final String errorMessages;
  final TextStyle? errorMessageStyle;
  final double errorLeftRightMargin;
  final Widget? lable;
  final BorderStyle? borderStyle;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  State<CommonTextFieldWithError> createState() =>
      _CommonTextFieldWithErrorState();
}

class _CommonTextFieldWithErrorState extends State<CommonTextFieldWithError> {
  FocusNode? focusNode;
  TextEditingController? controllerT;
  OverlayEntry? overlayEntry;
  // Timer? timerTemp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    controllerT = widget.controllerT ?? TextEditingController();
    focusNode?.addListener(() {
      if (Platform.isIOS || Platform.isAndroid) {
        if(widget.displayKeyBordDone!) {
          bool hasFocus = focusNode!.hasFocus;
          if (hasFocus) {
            showOverlay(context);
          } else {
            removeOverlay();
          }
        }
      }
    });

    // controllerT!.addListener((){
    //   print(">>>>>>>   ${controllerT!.value}");
    //   if(timerTemp==null){
    //
    //
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(widget.controllerT==null) {
      controllerT?.dispose();
    }

    // timerTemp?.cancel();

  }

  @override
  void didUpdateWidget(covariant CommonTextFieldWithError oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
//    print('people icon $inputFieldSuffixIcon');
    // Check if the keyboard is visible
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    TextCapitalization capitalizationTemp = TextCapitalization.sentences;
    switch (widget.capitalization) {
      case CapitalizationText.characters:
        capitalizationTemp = TextCapitalization.sentences;
        break;
      case CapitalizationText.words:
        capitalizationTemp = TextCapitalization.words;
        break;
      case CapitalizationText.none:
        capitalizationTemp = TextCapitalization.none;
        break;
      case CapitalizationText.sentences:
      // TODO: Handle this case.
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: widget.placeHolderEdgeInsets ??
              (widget.placeHolderTextWidget != null
                  ? const EdgeInsets.fromLTRB(0, 0, 0, 5)
                  : const EdgeInsets.fromLTRB(0, 0, 0, 0)),
          child: widget.placeHolderTextWidget,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: BoxDecoration(color: Colors.transparent, boxShadow: [
            BoxShadow(
                color: widget.isShowShadow == true?Colors.transparent:Colors.transparent,
                spreadRadius: 3,
                offset: const Offset(0, 1),
                blurRadius: 3)
          ]),
          child: Center(
            child: IgnorePointer(
              ignoring: !widget.isTextFieldEnabled,
              child: TextField(
                readOnly: widget.readOnly,
                autofocus: widget.autoFocus,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                onTap: (){
                  widget.onTapCallBack?.call();
                },
                inputFormatters: widget.inputFormatter ??
                    <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(
                          widget.maxCharLength),
                    ],
                textInputAction: widget.maxLines > 1
                    ? TextInputAction.newline
                    : (widget.textInputAction == null ||
                    widget.textInputAction == TextInputAction.done)
                    ? TextInputAction.done
                    : TextInputAction.next,
                // textAlign: textAlignment ?? TextAlign.left,
                // textAlignVertical: textAlignmentVertical == null
                //     ? TextAlignVertical.center
                //     : textAlignmentVertical,
                controller: controllerT,
                focusNode: focusNode,
                enabled: widget.isTextFieldEnabled,
                onChanged: (value) {
                  if (value.length <= widget.maxCharLength) {
                    //oldVal = value;
                    widget.onTextChange!(value);
                  } else {
                    controllerT!.text =
                        value.substring(0, widget.maxCharLength);
                  }
                },
                cursorColor: widget.cursorColor ?? Colors.grey,
                // ignore: unnecessary_null_comparison
                onSubmitted: (widget.maxCharLength != null)
                    ? (value) {
                  if (value.length <= widget.maxCharLength) {
                    //oldVal = value;
                    widget.onEndEditing!(value);
                  } else {
                    controllerT!.text =
                        value.substring(0, widget.maxCharLength);
                  }
                }
                    : widget.onEndEditing,
                style: widget.textStyle,
                obscureText: widget
                    .obscureText /*??
                    inputKeyboardType ==
                        InputKeyboardTypeWithError.password*/
                ,
                buildCounter: (
                    BuildContext? context, {
                      int? currentLength,
                      int? maxLength,
                      bool? isFocused,
                    }) =>
                widget.showCounterText
                    ? Text(
                  '$currentLength/$widget.maxCharLength',
                  style: counterTextStyle(
                      texColor: const Color(0xFF131313),
                      fontWeight: FontWeight.w300),
                  semanticsLabel: 'character count',
                )
                    : null,
                textCapitalization: capitalizationTemp,
                decoration: InputDecoration(
                  //   prefixText: inputFieldPrefixText??'',
                  contentPadding: widget.contentPadding ??
                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  suffixIcon: widget.inputFieldSuffixIcon,
                  /*     suffixIcon:inputFieldSuffixIcon == null
                      ? null
                      : inputFieldSuffixIcon is IconData
                          ? Icon(inputFieldSuffixIcon)
                      : iconTemp(inputFieldSuffixIcon),*/
                  prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
                  prefixIcon: widget.inputFieldPrefixIcon,
                  /*inputFieldPrefixIcon == null
                      ? null
                      : inputFieldPrefixIcon is IconData
                          ? Icon(inputFieldPrefixIcon)
                          : iconTemp(inputFieldPrefixIcon),*/
                  hintText: widget.hintText,
                  hintStyle: widget.hintStyle ??
                      const TextStyle(
                          color: Colors.grey,
                          backgroundColor: Colors.transparent),
                  labelText:
                  widget.labelText.isNotEmpty ? widget.labelText : null,
                  label: widget.lable,
                  labelStyle: widget.labelStyle ??
                      const TextStyle(
                          color: Colors.black,
                          backgroundColor: Colors.transparent),
                  // errorText: showError ? (errorText != null)?errorText:errorText : null,
                  floatingLabelBehavior: widget.floatingLabelBehavior ??
                      FloatingLabelBehavior.always,
                  errorStyle: widget.errorStyle ??
                      const TextStyle(color: Colors.white),
                  fillColor: widget.backgroundColor ?? Colors.white,
                  filled: true,
                  focusColor: Colors.blue,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius),
                    ),
                    borderSide: widget.errorText == null
                        ? BorderSide(
                      color: widget.isShowShadow == false ? Color(0xFFEEEEEE) : widget.enabledBorderColor,
                      width: widget.enabledBorderWidth ?? 1,
                      style: widget.borderStyle ?? BorderStyle.solid,
                    )
                        : BorderSide(
                      color: widget.isShowShadow == false ? Color(0xFFEEEEEE) :widget.enabledBorderColor,
                      width: widget.enabledBorderWidth ?? 1,
                      style: widget.borderStyle ?? BorderStyle.solid,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius),
                    ),
                    borderSide: widget.errorText != null
                        ? BorderSide(
                      // ignore: unnecessary_null_comparison
                      color: widget.isShowShadow == false ?AppColors.appBlueColor:widget.focusedBorderColor!,
                      width: widget.focusedBorderWidth ?? 1.5,
                      style: widget.borderStyle ?? BorderStyle.solid,
                    )
                        : BorderSide(
                      color: widget.isShowShadow == false ?AppColors.appBlueColor:widget.focusedBorderColor!,
                      width: widget.focusedBorderWidth ?? 1.5,
                      style: BorderStyle.none,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius),
                    ),
                    borderSide: BorderSide(
                      color: widget.enabledBorderColor ?? AppColors.textFiledBorderColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: widget.enabledBorderColor ?? AppColors.textFiledBorderColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: widget.errorBorderColor ?? AppColors.appErrorTextColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                keyboardType: widget.inputKeyboardType ==
                    InputKeyboardTypeWithError.email
                    ? TextInputType.emailAddress
                    : widget.inputKeyboardType ==
                    InputKeyboardTypeWithError.phone
                    ? TextInputType.phone
                    : widget.inputKeyboardType ==
                    InputKeyboardTypeWithError.text
                    ? TextInputType.text
                    : widget.inputKeyboardType ==
                    InputKeyboardTypeWithError.number
                    ? TextInputType.number
                    : widget.inputKeyboardType ==
                    InputKeyboardTypeWithError.multiLine
                    ? TextInputType.multiline
                    : widget.inputKeyboardType ==
                    InputKeyboardTypeWithError.numberWithDecimal
                    ? TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.text,
                maxLength: widget.maxLines > 1
                    ? widget.maxCharLength
                    : widget.maxCharLength
                // maxLengthEnforcement: MaxL,
                // maxLengthEnforced: true,
                /*style: TextStyle(
                  height: inputHeight,
                ),*/
              ),
            ),
          ),
        ),
        !widget.isShowBottomErrorMsg
            ? Container()
            : (widget.errorMessages != '')
            ? Container(
            margin: EdgeInsets.only(
                right: widget.errorLeftRightMargin * 2,
                left: widget.errorLeftRightMargin * 2),
            height: widget.errorMsgHeight ?? 24,
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0, left: 10),
              child: Text(
                widget.errorMessages,
                style: widget.errorMessageStyle ?? textErrorStyle(),
              ),
            ))
            : Container(
          height: widget.errorMsgHeight ?? 24,
        )
      ],
    );
  }

  TextStyle counterTextStyle(
      {Color? texColor,
        double? fontSize,
        fontFamily,
        fontWeight,
        bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.textNormalColor1,
        fontSize: fontSize ?? 13,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  TextStyle textErrorStyle(
      {Color? texColor, double? fontSize, fontFamily, fontWeight}) =>
      TextStyle(
        color: texColor ?? Colors.red,
        fontSize: fontSize ?? 10,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  //for ios done button callback
  onPressCallback(context) {
    widget.onEndEditing!(controllerT?.text.trim());
    removeOverlay();
    FocusScope.of(context).requestFocus(FocusNode());
  }


  void showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Position it correctly
        left: 0,
        right: 0,
        child: Container(
          width: double.infinity,
          color: const Color(0xFFFFFFFF),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
              child: CupertinoButton(
                padding: const EdgeInsets.only(right: 24.0, top: 3.0, bottom: 3.0),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  removeOverlay();
                  onPressCallback(context);
                },
                child: const Text("Done", style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ),
      ),
    );

    // Add the overlay without unfocusing the TextField
    overlayState.insert(overlayEntry!);

    // Remove the overlay after some delay if needed
    // Future.delayed(Duration(seconds: 4), () {
    //   overlayEntry!.remove();
    // });
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }
}

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