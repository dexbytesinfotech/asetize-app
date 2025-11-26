import 'package:asetize/imports.dart';

class SliverScrollViewWidget extends StatefulWidget {
  final double collapsedHeight;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? margin;
  final Widget slivers;
  final String? title;
  final String? imageUrl;
  final bool isShowTrailingIcon;
  final onPressTrailingButton;
  final Widget? leading;

  const SliverScrollViewWidget({
    Key? key,
    this.collapsedHeight = 55,
    this.textStyle,
    this.margin,
    required this.slivers,
    this.title,
    this.isShowTrailingIcon = false,
    this.onPressTrailingButton,
    this.leading,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<SliverScrollViewWidget> createState() => _SliverScrollViewWidgetState();
}

class _SliverScrollViewWidgetState extends State<SliverScrollViewWidget> {
  late double collapsedHeight;
  bool isAppBarCollapsed = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        print(_scrollController.position.pixels);

        isAppBarCollapsed =
            _scrollController.position.pixels >= collapsedHeight;
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double toolBarHeight = 56;
    collapsedHeight = toolBarHeight;

    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            slivers: <Widget>[
              SilverAppBarWidget(
                leading: widget.leading ??
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      icon: WorkplaceIcons.iconImage(
                        imageUrl: WorkplaceIcons.backArrow,
                        imageColor: Colors.black,
                        iconSize: const Size(14, 14), //imageColor:Colors.white
                      ),
                    ),
                isShowTrailingIcon: widget.isShowTrailingIcon,
                onPressTrailingButton: () {
                  widget.onPressTrailingButton?.call();
                },
                collapsedHeight: collapsedHeight,
                title: isAppBarCollapsed
                    ? Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(
                            right: AppDimens().widthFullScreen() / 5.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularImage(
                              height: 22,
                              width: 22,
                              image: widget.imageUrl ??
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPhFl6zHkAHKFN0kNZl0jhZLfgeYYy2WzbezLIKbdF0eBJgVBP0ZmkVClZuU61_fF1bSc&usqp=CAU",
                              name: "",
                              isClickToFullView: true,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(widget.title ?? "",
                                style: appStyles.userNameTextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )
                    : Container(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return widget.slivers;
                  },
                  childCount: 1,
                ),
              ),
            ]));
  }
}
