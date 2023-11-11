// ignore_for_file: unused_field, empty_constructor_bodies, camel_case_types

class userpayment {
  static final userpayment _session = userpayment._internal();
  double? bill;
  int? payment;
  String? uid;
  int? rent;
  String? roomId;
  String? hostelid;
  String? username;
  factory userpayment() {
    return _session;
  }

  userpayment._internal() {}
}
