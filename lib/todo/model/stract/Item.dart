class Item {
  late int id;
  late String name;
  bool? finished = false;
  String? targetGroupName;
  int? steps;
  int? hasDoneStep;
  bool star = false;
  bool? hasText;
  String? _date;
  DateTime? get data =>_date==null?null:DateTime.parse(_date!);
  
  List<dynamic>? step = null;
  List<dynamic>? done = null;
  

  Item({
    required this.id,
    required this.name,
      required this.finished,
      this.targetGroupName, 
      this.steps, 
      this.hasDoneStep, 
      required this.star,
      this.hasText,});

  Item.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    finished = json['finished'];
    targetGroupName = json['targetGroupName'];
    steps = json['steps'];
    hasDoneStep = json['hasDoneStep'];
    star = json['star'];
    hasText = json['hasText'];
    _date = json['date'];
    step = json['step'];
    done = json['done'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['finished'] = finished;
    map['targetGroupName'] = targetGroupName;
    map['steps'] = steps;
    map['hasDoneStep'] = hasDoneStep;
    map['star'] = star;
    map['hasText'] = hasText;
    map['data'] = _date;
    map['step'] = step;
    map['done'] = done;
    return map;
  }

  bool onlyHead() {
    return (targetGroupName==null||targetGroupName!.isEmpty)&&
        (steps==null||steps==0)&&
        (hasText==null||!hasText!)&&
        (_date==null||!_date!.isEmpty);
  }

}