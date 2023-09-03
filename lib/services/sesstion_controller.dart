// ignore_for_file: unused_field, empty_constructor_bodies

class SessionController {
  static final SessionController _session = SessionController._internal();
  String? userId;
  factory SessionController() {
    return _session;
  }

  SessionController._internal() {}
}
