// ignore_for_file: camel_case_types, empty_constructor_bodies, non_constant_identifier_names

class roomController {
  static final roomController _session = roomController._internal();
  String? roomId;
  String? seets;
  String? total_cpacity;
  String? rent;
  // String? avalibilty;
  factory roomController() {
    return _session;
  }

  roomController._internal() {}
}
