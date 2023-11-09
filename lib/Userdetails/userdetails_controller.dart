// ignore_for_file: unused_field, empty_constructor_bodies, camel_case_types

class userController {
  static final userController _session = userController._internal();
  String? userId;
  String? username;
  factory userController() {
    return _session;
  }

  userController._internal() {}
}
