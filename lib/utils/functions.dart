class UtilFunctions {
  static bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  static bool isNumeric(String? str) {
    if (str == null || str.isEmpty) {
      return false;
    }

    if (RegExp(r'[^0-9]').hasMatch(str)) {
      return false;
    }

    return true;
  }
}
