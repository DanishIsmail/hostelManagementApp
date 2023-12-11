// ignore_for_file: camel_case_types, empty_constructor_bodies, non_constant_identifier_names

class hostelName {
  static final hostelName _session = hostelName._internal();
  String? hostel;
  // String? avalibilty;
  factory hostelName() {
    return _session;
  }

  hostelName._internal() {}
}
