import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class CourseLearnStateWidget extends InheritedWidget {
  final CourseLearnState data;

  CourseLearnStateWidget({required this.data, Key? key, required Widget child})
      : super(key: key, child: child);

  static CourseLearnState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CourseLearnStateWidget>()!
        .data;
  }

  @override
  bool updateShouldNotify(covariant CourseLearnStateWidget oldWidget) {
    return oldWidget.data.playing_id != data.playing_id ;
    //||oldWidget.data.name != data.name||
    // oldWidget.data.isPlaying != data.isPlaying
  }
}

class CourseLearnState {
  // String expand_id;

  String playing_id;


  CourseLearnState(this.playing_id);

}
