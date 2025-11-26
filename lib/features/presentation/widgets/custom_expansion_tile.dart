import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:asetize/imports.dart';

class FaqExpansionTileWidget extends StatefulWidget {
  final void Function(bool)? onCardClickCallBack;
  final String? title;
  final TextStyle? titleTextStyle;
  final Widget? trailingIcon;
  final List<Widget> children;
  final bool initiallyExpanded;

  const FaqExpansionTileWidget({
    Key? key,
    this.onCardClickCallBack,
    this.title,
    this.trailingIcon,
    this.children = const [],
    this.titleTextStyle,
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  State<FaqExpansionTileWidget> createState() => _FaqExpansionTileWidgetState();
}

class _FaqExpansionTileWidgetState extends State<FaqExpansionTileWidget> {
  late num itemCount = 1;

  @override
  Widget build(BuildContext context) {
    AppDimens appDimens = AppDimens();
    appDimens.appDimensFind(context: context);

    return ExpansionTileWidget(
        initiallyExpanded: widget.initiallyExpanded,
        maintainState: true,
        onExpansionChanged: (z) {
          widget.onCardClickCallBack?.call(z);
        },
        // leading: Icon(cdm.icon,color: Colors.white),
        title: HtmlWidget(
          "${widget.title}",
          textStyle: widget.titleTextStyle ?? appStyles.userNameTextStyle(),
        ),
        // Text(
        //   "${widget.title}",
        //   style: widget.titleTextStyle ?? appStyles.userNameTextStyle(),
        // ),
        trailing: widget.trailingIcon,
        children: widget.children);
  }
}
