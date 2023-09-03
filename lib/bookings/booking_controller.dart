// ignore_for_file: camel_case_types, empty_constructor_bodies, non_constant_identifier_names

class bookingController {
  static final bookingController _session = bookingController._internal();
  int? bookingStatus;
  // String? avalibilty;
  factory bookingController() {
    return _session;
  }

  bookingController._internal() {}
}
