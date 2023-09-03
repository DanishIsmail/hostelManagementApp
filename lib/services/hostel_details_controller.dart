// ignore_for_file: empty_constructor_bodies

class HostelController {
  static final HostelController _session = HostelController._internal();
  String? hostelId;
  String? hostelName;
  factory HostelController() {
    return _session;
  }

  HostelController._internal() {}
}
