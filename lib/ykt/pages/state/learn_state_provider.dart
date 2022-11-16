
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class LearnState with ChangeNotifier,DiagnosticableTreeMixin{

  List? certs;

  int? cert_id;
  List? lectures;
  int? get certId => cert_id;

  void getCertsSuccess(List certs){
    this.certs = certs;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('cert_id',cert_id));
  }
}