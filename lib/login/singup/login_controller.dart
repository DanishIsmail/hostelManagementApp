// ignore_for_file: camel_case_types, empty_constructor_bodies, non_constant_identifier_names

class loginController {
  static final loginController _session = loginController._internal();
  int? checkuser;
  // String? avalibilty;
  factory loginController() {
    return _session;
  }

  loginController._internal() {}
}
