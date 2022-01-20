class Validation {
  static String? isEmail(String? value) {
    if (value != null) {
      if (value.contains(RegExp('@'))) {
        return null;
      }
      return 'email not valid !!';
    }
  }
}
