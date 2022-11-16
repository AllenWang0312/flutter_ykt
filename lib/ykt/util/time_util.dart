class TimeUtil {
  static String durationTransform(int seconds) {
    var d = Duration(seconds: seconds);
    List<String> parts = d.toString().split('.')[0].split(':');
    if (int.parse(parts[0]) > 0) {
      return '${parts[0]}小时${parts[1]}分';
    } else {
      return '${parts[1]}分${parts[2]}秒';
    }
  }
}
