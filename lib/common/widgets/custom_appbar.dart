import 'package:flutter/material.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight;
  Color navigationBarBackgroundColor;

  String? title;

  Widget? leadingWidget;
  Widget? trailingWidget;
  Widget? child;

  CustomAppbar({
    this.title,
    this.child,
    this.leadingWidget,
    this.trailingWidget,

    this.contentHeight = 48,
    this.navigationBarBackgroundColor = Colors.white,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomAppbarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(contentHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.navigationBarBackgroundColor,
      child: SafeArea(
        top: true,
        child: Container(
          decoration: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 1.0, color: Color(0xFFeeeeee)),
          ),
          height: widget.contentHeight,
          child: Stack(alignment: Alignment.center, children: createToolbar()),
        ),
      ),
    );
  }

  List<Widget> createToolbar() {
    List<Widget> stacks = List.empty(growable: true);

    if (null != widget.leadingWidget) {
      stacks.add(Positioned(
        left: 0,
        child: Container(
          padding: const EdgeInsets.only(left: 16),
          child: widget.leadingWidget,
        ),
      ));
    }
    if (null != widget.title && widget.title!.isNotEmpty) {
      stacks.add(Text(
        widget.title!,
        style: const TextStyle(fontSize: 17, color: Color(0xFF333333)),
      ));
    }
    if (null != widget.child) {
      stacks.add(Align(
        alignment: Alignment.center,
        child: widget.child,
      ));
    }
    if (null != widget.trailingWidget) {
      stacks.add(Positioned(
        right: 0,
        child: Container(
          padding: const EdgeInsets.only(right: 5),
          child: widget.trailingWidget,
        ),
      ));
    }
    return stacks;
  }
}
