import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';

import '../view/order_v.dart';

class OrderViewModel extends PageViewModel {

  OrderViewState? state;

  @override
  onCreate() {
    state = (viewState as OrderViewState);
    assert((){
      debugPrint('state: --- ${state?.paramsModel}');
      return true;
    }());
  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
      return Future.value(null);
  }
}