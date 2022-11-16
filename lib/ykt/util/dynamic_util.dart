

class Util{
   static safeGetInt(dynamic obj,String key){
    String target = obj[key];
    if(target.isEmpty){
      return -1;
    }
    return int.parse(target);
  }
}