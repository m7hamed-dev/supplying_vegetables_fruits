import 'package:flutter_easyloading/flutter_easyloading.dart';

class Toast {
  static void error({String? error}) {
    EasyLoading.showError(error ?? 'Failed with Error');
  }

  static void success({String? msg}) {
    EasyLoading.showSuccess(msg ?? 'Great Success!');
  }

  static void loading({String? msg}) {
    EasyLoading.show();
  }
}
