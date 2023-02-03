import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_ykt/data/banner_response.dart';
import '../../common/util/platform_util.dart';

class BannerView extends StatelessWidget {
  List<Data>? swiperDataList;

  BannerView(this.swiperDataList);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: CachedNetworkImage(
              imageUrl: "${swiperDataList![index].imageurl}",
              fit: BoxFit.cover,
            ),
            onTap: () {
              PlatformUtil.loadUrl(context,"活动详情",swiperDataList![index].linkurl!);
            },
          );
        },
        itemCount: swiperDataList!.length,
        autoplay: true,
      ),
    );
  }
}
