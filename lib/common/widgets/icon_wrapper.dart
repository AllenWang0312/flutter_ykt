
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconWrapper extends StatelessWidget{

  double size;
  Function()? onTap;
  IconData icon;
  EdgeInsetsGeometry? margin;


  IconWrapper(this.size,this.icon, this.onTap,{this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      child: InkWell(
        onTap: onTap,
        child: Icon(icon)
      ),
    );
  }

}