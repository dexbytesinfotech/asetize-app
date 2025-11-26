import 'package:asetize/imports.dart';

class Bubble {
  const Bubble({
    required this.title,
    required this.titleStyle,
    required this.iconColor,
    required this.bubbleColor,
    this.icon,
    this.isHideIcon = false,
    this.iconSize = 20,
    required this.onPress,
  });

  final String? icon;
  final Color iconColor;
  final Color bubbleColor;
  final double iconSize;
  final bool isHideIcon;
  final void Function() onPress;
  final String title;
  final TextStyle titleStyle;
}

class BubbleMenu extends StatelessWidget {
  const BubbleMenu(this.item, {Key? key}) : super(key: key);

  final Bubble item;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      color: item.bubbleColor,
      splashColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.1),
      elevation: 1,
      highlightElevation: 2,
      disabledColor: item.bubbleColor,
      onPressed: item.onPress,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          item.isHideIcon
              ? Container()
              : WorkplaceIcons.iconImage(
                  iconSize: Size(item.iconSize, item.iconSize),
                  imageColor: item.iconColor,
                  imageUrl: item.icon ?? WorkplaceIcons.clockIcon,
                ),
          SizedBox(
            width: item.isHideIcon ? 0 : 7,
          ),
          Text(
            item.title,
            style: item.titleStyle,
          ),
        ],
      ),
    );
  }
}

class _DefaultHeroTag {
  const _DefaultHeroTag();
  @override
  String toString() => '<default FloatingActionBubble tag>';
}

class FloatingActionBubble extends AnimatedWidget {
  const FloatingActionBubble({
    Key? key,
    required this.items,
    required this.onPress,
    required this.iconColor,
    required this.backGroundColor,
    required Animation animation,
    this.heroTag,
    this.iconData,
    this.startAnimatedIconData,
    this.endAnimatedIconData,
  }) : super(listenable: animation, key: key);

  final List<Bubble> items;
  final void Function() onPress;
  final IconData? startAnimatedIconData;
  final IconData? endAnimatedIconData;
  final Object? heroTag;
  final IconData? iconData;
  final Color iconColor;
  final Color backGroundColor;

  get _animation => listenable;

  Widget buildItem(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;

    TextDirection textDirection = Directionality.of(context);

    double animationDirection = textDirection == TextDirection.rtl ? -1 : 1;

    final transform = Matrix4.translationValues(
      animationDirection *
          (screenWidth - _animation.value * screenWidth) *
          ((items.length - index) / 10),
      0.0,
      0.0,
    );

    return Align(
      alignment: textDirection == TextDirection.ltr
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Transform(
        transform: transform,
        child: Opacity(
          opacity: _animation.value,
          child: BubbleMenu(items[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IgnorePointer(
          ignoring: _animation.value == 0,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 5.0),
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: items.length,
            itemBuilder: buildItem,
          ),
        ),
        FloatingActionButton(
          elevation: 5,
          heroTag: heroTag ?? const _DefaultHeroTag(),
          backgroundColor: backGroundColor,
          onPressed: onPress,
          // iconData is mutually exclusive with animatedIconData
          // only 1 can be null at the time
          child: iconData == null
              ? SimpleAnimatedIcon(
                  startIcon: startAnimatedIconData ?? Icons.add,
                  endIcon: endAnimatedIconData ?? Icons.close,
                  progress: _animation,
                  color: iconColor,
                  size: 28,
                )
              : Icon(
                  iconData,
                  color: iconColor,
                ),
        ),
      ],
    );
  }
}
