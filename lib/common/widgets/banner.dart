
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class BannerView extends StatelessWidget {
  List swiperDataList;
  BannerView(this.swiperDataList);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      color: Colors.white,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: CachedNetworkImage(
              imageUrl: "${swiperDataList[index]['imageurl']}",
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: swiperDataList.length,
        autoplay: true,
      ),
    );
  }
}