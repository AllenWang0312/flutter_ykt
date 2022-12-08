class ArrayUtil {
  static void reorder<T>(List<T> list, int oldIndex, int newIndex) {
    T item = list[oldIndex];
    list.remove(item);
    list.insert(newIndex, item);
  }

  static int nullableListSize(List? list){
    if(list==null){
      return 0;
    }
    return list.length;
  }
}
