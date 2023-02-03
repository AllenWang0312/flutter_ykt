

class Util{
   static safeGetInt(dynamic obj,String key){
    dynamic target = obj[key];
    if(target is int){
      return target;
    }
    if(null==target||target.isEmpty){
      return -1;
    }
    return int.parse(target);
  }
}