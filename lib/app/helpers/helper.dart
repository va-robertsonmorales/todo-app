import 'package:uuid/uuid.dart';

class Helper {
  String generateGuid() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
