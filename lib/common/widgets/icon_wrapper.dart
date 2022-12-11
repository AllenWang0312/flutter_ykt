import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconWrapper extends StatelessWidget {

  double size;
  Function()? onTap;
  IconData icon;
  Widget? right;
  EdgeInsetsGeometry? margin;


  IconWrapper(this.size, this.icon, this.onTap, {this.right, this.margin});

  @override
  Widget build(BuildContext context) {
    if (right == null) {
      return Container(
        width: size,
        height: size,
        margin: margin,
        child: InkWell(
          onTap: onTap,
          child: Icon(icon),
        ),
      );
    } else {
      return InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: size,
                height: size,
                margin: margin,
                child: Icon(icon),
              ),
              Flexible(
                fit: FlexFit.tight,
                  child: right!),
            ],
          ),
        );
  }


  }

}