import 'package:flutter/material.dart';

class BaseChangeNotifier extends ChangeNotifier {

  /// 刷新UI
  refreshState() => notifyListeners();

}