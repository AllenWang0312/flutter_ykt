

class TextUtil{
  static String fromNullableInt(int? value){
    if(value==null){
      return "";
    }
    return value.toString();
  }
}