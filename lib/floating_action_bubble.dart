import 'package:flutter/material.dart';

class Bubble {
  const Bubble({
    required this.title,
    required this.titleStyle,
    this.iconColor,
    required this.bubbleColor,
    this.icon,
    required this.onPress,
  });

  final IconData? icon;
  final Color? iconColor;
  final Color bubbleColor;
  final void Function() onPress;
  final String title;
  final TextStyle titleStyle;
}

class BubbleMenu extends StatelessWidget {
  const BubbleMenu(this.item, {Key? key}) : super(key: key);

  final Bubble item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: MaterialButton(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.only(top: 11, bottom: 13, left: 32, right: 32),
        color: item.bubbleColor,
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.grey.withOpacity(0.1),
        elevation: 2,
        highlightElevation: 2,
        disabledColor: item.bubbleColor,
        onPressed: item.onPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            item.icon != null
                ? Icon(
                    item.icon,
                    color: item.iconColor,
                  )
                : const SizedBox(),
            item.icon != null
                ? const SizedBox(
                    width: 10.0,
                  )
                : const SizedBox(),
            Text(
              item.title,
              style: item.titleStyle,
            ),
          ],
        ),
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
    required this.height,
    required this.items,
    required this.onPress,
    required this.iconColor,
    required this.backGroundColor,
    required Animation animation,
    this.heroTag,
    this.iconData,
    this.animatedIconData,
  })  : assert((iconData == null && animatedIconData != null) ||
            (iconData != null && animatedIconData == null)),
        super(listenable: animation, key: key);
  final double height;
  final List<Bubble> items;
  final void Function() onPress;
  final AnimatedIconData? animatedIconData;
  final Object? heroTag;
  final IconData? iconData;
  final Color iconColor;
  final Color backGroundColor;

  get _animation => listenable;

  Widget buildItem(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;

    TextDirection textDirection = Directionality.of(context);

    double animationDirection = textDirection == TextDirection.ltr ? -1 : 1;

    final transform = Matrix4.translationValues(
      animationDirection *
          (screenWidth - _animation.value * screenWidth) *
          ((items.length - index) / 4),
      0.0,
      0.0,
    );

    return Align(
      alignment: textDirection == TextDirection.ltr ? Alignment.centerRight : Alignment.centerLeft,
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
        SizedBox(
          height: height,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IgnorePointer(
                  ignoring: _animation.value == 0,
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: items.length,
                    itemBuilder: buildItem,
                  ),
                ),
              ],
            ),
          ),
        ),
        FloatingActionButton(
          heroTag: heroTag ?? const _DefaultHeroTag(),
          backgroundColor: backGroundColor,
          // iconData is mutually exclusive with animatedIconData
          // only 1 can be null at the time
          child: iconData == null
              ? AnimatedIcon(
                  icon: animatedIconData!,
                  progress: _animation,
                  color: iconColor,
                )
              : Icon(
                  iconData,
                  color: iconColor,
                ),
          onPressed: onPress,
        ),
      ],
    );
  }
}
